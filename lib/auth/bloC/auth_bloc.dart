import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../core/services/token_service.dart';
import '../models/User.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../core/enums/user_roles.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      try {
        emit(AuthLoading());
        final response = await _authService.login(event.email, event.password);

        if (response['token'] == null || response['role'] == null) {
          throw Exception('Invalid response format');
        }

        // Store the token
        final token = response['token'] as String;
        TokenService.setToken(token);

        final decodedToken = JwtDecoder.decode(token);

        // Create user with proper role conversion
        final user = User(
          id: decodedToken['userId'] ?? '',
          name: event.email.split('@')[0],
          email: event.email,
          role: UserRole.values.firstWhere(
            (r) => r.toString().split('.').last == response['role'],
            orElse: () => UserRole.customer,
          ),
        );

        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      try {
        emit(AuthLoading());
        final response = await _authService.register(
          event.name,
          event.email,
          event.password,
          event.role,
        );

        if (response['token'] == null || response['role'] == null) {
          throw Exception('Invalid response format');
        }

        final token = response['token'] as String;
        TokenService.setToken(token);

        final decodedToken = JwtDecoder.decode(token);

        final user = User(
          id: decodedToken['userId'] ?? '',
          name: event.name,
          email: event.email,
          role: UserRole.values.firstWhere(
            (r) => r.toString().split('.').last == response['role'],
            orElse: () => UserRole.customer,
          ),
        );

        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) {
      try {
        TokenService.clearToken();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
