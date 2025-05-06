abstract class OrderEvent {}

class CreateOrder extends OrderEvent {
  final String shippingAddress;

  CreateOrder({required this.shippingAddress});
}

class FetchOrders extends OrderEvent {}

class FetchMyOrders extends OrderEvent {}
