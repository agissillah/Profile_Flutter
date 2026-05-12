import 'package:flutter/foundation.dart';

import '../domain/entities/auth_session.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.errorMessage});

  final String? errorMessage;
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.session});

  final AuthSession session;
}
