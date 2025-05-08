import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart_item.dart';
import '../../core/constants/api_constants.dart';
import '../../core/services/token_service.dart';


class CartService {
  final String baseUrl = ApiConstants.baseUrl;

  Map<String, String> get headers {
    final token = TokenService.getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<CartItem>> fetchCart() async {
    final response = await http.get(
      Uri.parse('$baseUrl/cart'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> cartData = json.decode(response.body)['items'];
      return cartData.map((item) => CartItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch cart');
    }
  }

  Future<void> addToCart(String productId, int quantity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/add'),
      headers: headers,
      body: json.encode({
        'productId': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add item to cart');
    }
  }

  Future<void> removeFromCart(String productId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/remove'),
      headers: headers,
      body: json.encode({
        'productId': productId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove item from cart');
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/cart/$productId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenService.getToken()}',
      },
      body: json.encode({'quantity': quantity}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update quantity');
    }
  } catch (e) {
    throw Exception('Failed to update quantity: $e');
  }
}

  Future<void> clearCart() async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/clear'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to clear cart');
    }
  }
}