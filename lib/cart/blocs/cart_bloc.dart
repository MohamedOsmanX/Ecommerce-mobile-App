import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_events.dart';
import 'cart_state.dart';
import '../services/cart_service.dart';

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
      final items = await _cartService.fetchCart();
      emit(CartUpdated(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await _cartService.addToCart(event.product.id, 1);
      add(FetchCart()); // Refresh cart after adding item
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    try {
      await _cartService.removeFromCart(event.product.id);
      add(FetchCart()); // Refresh cart after removing item
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await _cartService.clearCart();
      emit(CartUpdated([]));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onIncreaseQuantity(IncreaseQuantity event, Emitter<CartState> emit) async {
    try {
      await _cartService.addToCart(event.product.id, 1);
      add(FetchCart());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

Future<void> _onDecreaseQuantity(DecreaseQuantity event, Emitter<CartState> emit) async {
  if (state is CartUpdated) {
    try {
      final currentState = state as CartUpdated;
      final item = currentState.items.firstWhere(
        (item) => item.product.id == event.product.id,
      );
      
      if (item.quantity > 1) {
        await _cartService.updateQuantity(event.product.id, item.quantity - 1);
        add(FetchCart());
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
}