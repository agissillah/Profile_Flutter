class AuthSession {
  const AuthSession({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
  });

  final int id;
  final String username;
  final String email;
  final String token;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final tokenValue = json['accessToken'] ?? json['token'];

    return AuthSession(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      token: tokenValue?.toString() ?? '',
    );
  }
}
