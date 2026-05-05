import 'package:flutter/foundation.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

final class LoginSubmitted extends AuthEvent {
  const LoginSubmitted({required this.username, required this.password});

  final String username;
  final String password;
}

final class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
