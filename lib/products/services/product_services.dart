import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import '../../core/constants/api_constants.dart';
import '../../core/services/token_service.dart';
import '../models/product.dart';

class ProductServices {
  static const String baseUrl = ApiConstants.baseUrl;

  Map<String, String> get headers {
    final token = TokenService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Product>> fetchProducts() async {
    try {
      developer.log('Fetching products...');
      final response = await http.get(
        Uri.parse('$baseUrl/api/products'),
        headers: headers,
      );

      developer.log('Response status: ${response.statusCode}');
      developer.log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      developer.log('Error fetching products: $e');
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Product> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<Product> fetchProductById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<Product> updateProduct(String id, Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<bool> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete product');
    }
  }
}
