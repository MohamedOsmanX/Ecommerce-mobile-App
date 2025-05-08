import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_event.dart';
import 'order_state.dart';
import '../services/order_service.dart';
import '../../notification/services/notification_service.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderService _orderService;
  final NotificationService _notificationService;

  OrderBloc(this._orderService, this._notificationService)
    : super(OrderInitial()) {
    on<CreateOrder>(_onCreateOrder);
    on<FetchOrders>(_onFetchOrders);
    on<FetchMyOrders>(_onFetchMyOrders);
  }

Future<void> _onCreateOrder(CreateOrder event, Emitter<OrderState> emit) async {
  print('Starting order creation process...');
  emit(OrderLoading());
  
  try {
    // Try to create the order
    final order = await _orderService.createOrder(event.shippingAddress);
    print('Order created successfully with ID: ${order.id}');
    
    // Only send notification if order creation was successful
    try {
      print('Attempting to send notification...');
      await _notificationService.sendOrderNotification(
        order.id,
        'confirmed'
      );
      print('Notification sent successfully');
    } catch (notificationError) {
      print('Notification failed but order was created: $notificationError');
      // Don't emit error state since order was created successfully
    }
    
    emit(OrderSuccess(order));
  } catch (e) {
    print('Order creation failed with error: $e');
    if (e.toString().contains('500')) {
      emit(OrderError('Server error occurred. Please try again later.'));
    } else {
      emit(OrderError(e.toString()));
    }
  }
}

  Future<void> _onFetchOrders(
    FetchOrders event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final orders = await _orderService.getOrders();
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onFetchMyOrders(
    FetchMyOrders event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final orders = await _orderService.getUserOrders();
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
