import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/orders.dart';
import '../../core/constants/api_constants.dart';
import 'package:dio/dio.dart';


class OrderService {
  final Dio _dio;
  final String baseUrl = ApiConstants.baseUrl; // Make sure this is set correctly

  OrderService() : _dio = Dio(BaseOptions(
    baseUrl: 'YOUR_API_URL',
    validateStatus: (status) => status! < 500,
  ));

  Future<Order> createOrder(String shippingAddress) async {
    try {
      final response = await _dio.post(
        '/api/orders/create',
        data: {'shippingAddress': shippingAddress},
      );

      if (response.statusCode == 201) {
        return Order.fromJson(response.data);
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      final response = await _dio.get('/api/orders/my-orders');

      if (response.statusCode == 200) {
        final List<dynamic> ordersJson = response.data;
        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }
}