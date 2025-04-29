enum UserRole {
  customer,
  seller;

  static UserRole fromJson(String role) {
    return UserRole.values.firstWhere(
      (r) => r.toString().split('.').last == role,
      orElse: () => UserRole.customer,
    );
  }

  String toJson() => toString().split('.').last;
}
