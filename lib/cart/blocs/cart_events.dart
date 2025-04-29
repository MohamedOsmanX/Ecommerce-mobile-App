import '../../products/models/product.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  AddToCart(this.product);
}

class FetchCart extends CartEvent {
  FetchCart();
}

class RemoveFromCart extends CartEvent {
  final Product product;
  RemoveFromCart(this.product);
}

class IncreaseQuantity extends CartEvent {
  final Product product;
  IncreaseQuantity(this.product);
}


class DecreaseQuantity extends CartEvent {
  final Product product;
  DecreaseQuantity(this.product);
}

class ClearCart extends CartEvent {}
