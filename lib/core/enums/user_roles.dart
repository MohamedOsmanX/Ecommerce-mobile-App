import 'dart:developer' as developer;

enum UserRole {
  customer,
  seller,
  admin;  // Added admin role

  static UserRole fromJson(String role) {
    // Add logging to debug role parsing
    developer.log('Parsing role from JSON: $role');
    
    return UserRole.values.firstWhere(
      (r) => r.toString().split('.').last.toLowerCase() == role.toLowerCase(),
      orElse: () {
        developer.log('Role not found, defaulting to customer');
        return UserRole.customer;
      },
    );
  }

  String toJson() => toString().split('.').last.toLowerCase();
}