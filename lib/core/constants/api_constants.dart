class ApiConstants {
  // Base URL for your backend API
  static const String baseUrl = 'http://10.255.254.84:8080/api';
  
  // Common API endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String products = '/api/products';
  static const String cart = '/api/cart';
  
  // Default headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };
  
  // Add authentication header
  static Map<String, String> getAuthHeaders(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}
