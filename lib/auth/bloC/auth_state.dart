import '../models/User.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final String token;

  AuthAuthenticated(this.user, this.token);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
