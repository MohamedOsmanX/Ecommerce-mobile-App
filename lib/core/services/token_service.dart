class TokenService {
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static String? getToken() {
    return _token;
  }

  static bool hasToken() {
    return _token != null && _token!.isNotEmpty;
  }

  static void clearToken() {
    _token = null;
  }
}