import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import '../../core/constants/api_constants.dart';
import '../../core/services/token_service.dart';
import '../models/product.dart';
import '../models/pagination_response.dart';

class ProductServices {
  static const String baseUrl = ApiConstants.baseUrl;

  Map<String, String> get headers {
    final token = TokenService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<PaginatedResponse<Product>> getProducts({
    required int page,
    required int limit,
  }) async {
    try {
      developer.log('Fetching products: page=$page, limit=$limit');
      
      final response = await http.get(
        Uri.parse('$baseUrl/products?page=$page&limit=$limit'),
        headers: headers,
      );

      developer.log('Response status: ${response.statusCode}');
      developer.log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return PaginatedResponse.fromJson(
          json,
          (productJson) => Product.fromJson(productJson),
        );
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error fetching products', error: e);
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<Product> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products/create'),
        headers: headers,
        body: json.encode(product.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to add product: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error adding product', error: e);
      throw Exception('Failed to add product: $e');
    }
  }

  Future<Product> fetchProductById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error fetching product by id', error: e);
      throw Exception('Failed to load product: $e');
    }
  }

  Future<Product> updateProduct(String id, Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/$id'),
        headers: headers,
        body: json.encode(product.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error updating product', error: e);
      throw Exception('Failed to update product: $e');
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error deleting product', error: e);
      throw Exception('Failed to delete product: $e');
    }
  }
}