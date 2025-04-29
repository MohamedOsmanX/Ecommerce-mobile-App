import '../../core/enums/user_roles.dart';

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: UserRole.fromJson(json['role']),
    );
  }

  bool hasRole(UserRole role) => this.role == role;
  bool hasAnyRole(List<UserRole> roles) => roles.contains(role);
}