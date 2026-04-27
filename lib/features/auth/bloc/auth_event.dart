import 'package:flutter/foundation.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

final class LoginSubmitted extends AuthEvent {
  const LoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;
}

final class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
