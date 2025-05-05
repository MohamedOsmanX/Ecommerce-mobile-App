import '../../cart/models/cart_item.dart';

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final String shippingAddress;
  final OrderStatus status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.shippingAddress,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      items:
          (json['items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList(),
      total: json['total'].toDouble(),
      shippingAddress: json['shippingAddress'],
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
