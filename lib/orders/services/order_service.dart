import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/orders.dart';
import '../../core/constants/api_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloC/auth_bloc.dart';
import '../../auth/bloC/auth_state.dart';

class OrderService {
  final String baseUrl = ApiConstants.baseUrl;
  final BuildContext context;

  OrderService(this.context);

  String? _getToken() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.token;
    }
    return null;
  }

  Future<List<Order>> getOrders() async {
    try {
      final token = _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/orders/all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> ordersJson = json.decode(response.body);
        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

    Future<List<Order>> getUserOrders() async {
  try {
    final token = _getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    print('Fetching orders with token: $token');
    print('Using URL: $baseUrl/orders/my');

    final response = await http.get(
      Uri.parse('$baseUrl/orders/my'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> ordersJson = json.decode(response.body);
      return ordersJson.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch orders: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching orders: $e');
    throw Exception('Failed to fetch orders: $e');
  }
}

  Future<Order> createOrder(String shippingAddress) async {
    try {
      final token = _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/orders/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'shippingAddress': shippingAddress,
        }),
      );

      if (response.statusCode == 201) {
        return Order.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }
}