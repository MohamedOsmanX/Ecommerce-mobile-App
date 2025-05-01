import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_events.dart';
import 'cart_state.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';
import 'dart:developer' as developer;

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService _cartService;

  CartBloc(this._cartService) : super(CartInitial()) {
    on<FetchCart>(_onFetchCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
    on<IncreaseQuantity>(_onIncreaseQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
  }

  Future<void> _onFetchCart(FetchCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      developer.log('Fetching cart items');
      final List<CartItem> items = await _cartService.fetchCart();
      developer.log('Cart items fetched: ${items.length} items');
      emit(CartUpdated(items));
    } catch (e) {
      developer.log('Error fetching cart', error: e);
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      developer.log('Adding item to cart: ${event.product.id}');
      await _cartService.addToCart(event.product.id, 1);
      add(FetchCart());
    } catch (e) {
      developer.log('Error adding to cart', error: e);
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartUpdated) {
      try {
        final currentItems = (state as CartUpdated).items;
        // Optimistically update the UI by filtering out the removed item
        final updatedItems =
            currentItems
                .where((item) => item.product.id != event.product.id)
                .toList();

        // Update UI immediately
        emit(CartUpdated(updatedItems));

        // Then update the backend
        developer.log('Removing item from cart: ${event.product.id}');
        await _cartService.removeFromCart(event.product.id);
      } catch (e) {
        developer.log('Error removing from cart', error: e);
        // If error occurs, refresh the cart to get the correct state
        add(FetchCart());
        emit(CartError('Failed to remove item'));
      }
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      developer.log('Clearing cart');
      await _cartService.clearCart();
      emit(CartUpdated([]));
    } catch (e) {
      developer.log('Error clearing cart', error: e);
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onIncreaseQuantity(
    IncreaseQuantity event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartUpdated) {
      try {
        final currentItems = (state as CartUpdated).items;
        // Optimistically update the UI
        final updatedItems =
            currentItems.map((item) {
              if (item.product.id == event.product.id) {
                return CartItem(
                  product: item.product,
                  quantity: item.quantity + 1,
                );
              }
              return item;
            }).toList();

        emit(CartUpdated(updatedItems));

        // Update in background
        await _cartService.updateQuantity(
          event.product.id,
          updatedItems
              .firstWhere((item) => item.product.id == event.product.id)
              .quantity,
        );
      } catch (e) {
        developer.log('Error increasing quantity', error: e);
        // If error occurs, refresh the cart to get the correct state
        add(FetchCart());
      }
    }
  }

  Future<void> _onDecreaseQuantity(
    DecreaseQuantity event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartUpdated) {
      try {
        final currentState = state as CartUpdated;
        final item = currentState.items.firstWhere(
          (item) => item.product.id == event.product.id,
        );

        if (item.quantity > 1) {
          // Optimistically update the UI
          final updatedItems =
              currentState.items.map((cartItem) {
                if (cartItem.product.id == event.product.id) {
                  return CartItem(
                    product: cartItem.product,
                    quantity: cartItem.quantity - 1,
                  );
                }
                return cartItem;
              }).toList();

          // Update UI immediately
          emit(CartUpdated(updatedItems));

          // Then update the backend
          developer.log('Updating quantity for item: ${event.product.id}');
          await _cartService.updateQuantity(
            event.product.id,
            item.quantity - 1,
          );
        }
      } catch (e) {
        developer.log('Error decreasing quantity', error: e);
        // Only fetch cart if the operation failed
        add(FetchCart());
        emit(CartError('Failed to update quantity'));
      }
    }
  }
}
