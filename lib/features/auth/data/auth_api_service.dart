import 'dart:convert';

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthApiService {
  static const Map<String, String> _dummyUsers = <String, String>{
    'admin': 'admin123',
  };

  Future<String> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password.trim();

    final expectedPassword = _dummyUsers[normalizedEmail];
    if (expectedPassword == null || expectedPassword != normalizedPassword) {
      throw AuthException('Email atau password salah (dummy API).');
    }

    final rawToken =
        '$normalizedEmail:${DateTime.now().millisecondsSinceEpoch}';
    return base64UrlEncode(utf8.encode(rawToken));
  }
}
