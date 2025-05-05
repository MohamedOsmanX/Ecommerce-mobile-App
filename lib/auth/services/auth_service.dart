import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import '../../core/constants/api_constants.dart';

class AuthService {
  static const String baseUrl = ApiConstants.baseUrl;

   Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Get token for API requests
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Clear token on logout
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      developer.log('Attempting login with email: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      developer.log('Response status: ${response.statusCode}');
      developer.log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception('Empty response from server');
        }
        developer.log('Login successful: ${data.toString()}');
        return data;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to login');
      }
    } catch (e) {
      developer.log('Login error: ${e.toString()}', error: e);
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // In the register method:
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      developer.log('Attempting registration: $email, role: $role');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      developer.log('Response status: ${response.statusCode}');
      developer.log('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        developer.log('Registration successful: ${data.toString()}');
        return data;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Registration failed');
      }
    } catch (e) {
      developer.log('Registration error: ${e.toString()}', error: e);
      throw Exception('Registration failed: ${e.toString()}');
    }
  }
}
