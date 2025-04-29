import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart_item.dart';
import 'cart_events.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartItem> _cartItems = [];

  CartBloc() : super(CartInitial()) {
    on<AddToCart>((event, emit) {
      final index = _cartItems.indexWhere(
        (item) => item.product.id == event.product.id,
      );

      if (index >= 0) {
        _cartItems[index].quantity++;
      } else {
        _cartItems.add(CartItem(product: event.product));
      }

      emit(CartUpdated(List.from(_cartItems)));
    });

    on<RemoveFromCart>((event, emit) {
      _cartItems.removeWhere((item) => item.product.id == event.product.id);
      emit(CartUpdated(List.from(_cartItems)));
    });

    on<IncreaseQuantity>((event, emit) {
      final index = _cartItems.indexWhere(
        (item) => item.product.id == event.product.id,
      );
      if (index >= 0) {
        _cartItems[index].quantity++;
        emit(CartUpdated(List.from(_cartItems)));
      }
    });

    on<DecreaseQuantity>((event, emit) {
      final index = _cartItems.indexWhere(
        (item) => item.product.id == event.product.id,
      );
      if (index >= 0 && _cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
        emit(CartUpdated(List.from(_cartItems)));
      }
    });

    on<ClearCart>((event, emit) {
      _cartItems.clear();
      emit(CartUpdated(List.from(_cartItems)));
    });
  }
}
