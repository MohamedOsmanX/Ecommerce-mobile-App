import '../models/User.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class LoginSuccess extends AuthEvent {
  final User user;
  final String token;

  LoginSuccess({required this.user, required this.token});
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String role;

  RegisterRequested(this.name, this.email, this.password, this.role);
}

class LogoutRequested extends AuthEvent {}
