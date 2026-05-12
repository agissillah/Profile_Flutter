import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/errors/auth_failure.dart';
import '../domain/usecases/login.dart';
import '../domain/usecases/logout.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase login,
    required LogoutUseCase logout,
  })  : _login = login,
        _logout = logout,
        super(const AuthUnauthenticated()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final LoginUseCase _login;
  final LogoutUseCase _logout;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final session = await _login(
        username: event.username,
        password: event.password,
      );

      emit(AuthAuthenticated(session: session));
    } on AuthFailure catch (error) {
      emit(AuthUnauthenticated(errorMessage: error.message));
    } catch (_) {
      emit(
        const AuthUnauthenticated(
          errorMessage: 'Terjadi kesalahan tidak terduga.',
        ),
      );
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logout();
    emit(const AuthUnauthenticated());
  }
}
