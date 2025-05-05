import '../models/orders.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final Order order;

  OrderSuccess(this.order);
}

class OrderLoaded extends OrderState {
  final List<Order> orders;

  OrderLoaded(this.orders);
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}
