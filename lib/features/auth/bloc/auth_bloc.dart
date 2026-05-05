import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_api_service.dart';
import '../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository repository})
    : _repository = repository,
      super(const AuthUnauthenticated()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _repository;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final session = await _repository.login(
        username: event.username,
        password: event.password,
      );

      emit(AuthAuthenticated(session: session));
    } on AuthException catch (error) {
      emit(AuthUnauthenticated(errorMessage: error.message));
    } catch (_) {
      emit(
        const AuthUnauthenticated(
          errorMessage: 'Terjadi kesalahan tidak terduga.',
        ),
      );
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(const AuthUnauthenticated());
  }
}
