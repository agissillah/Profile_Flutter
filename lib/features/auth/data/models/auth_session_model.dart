import '../../domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.id,
    required super.username,
    required super.email,
    required super.token,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final tokenValue = json['accessToken'] ?? json['token'];

    return AuthSessionModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      token: tokenValue?.toString() ?? '',
    );
  }
}
