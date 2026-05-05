import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_session.dart';

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthApiService {
  static const String _usersUrl =
      'https://raw.githubusercontent.com/Ovi/DummyJSON/master/database/users.json';
  static const Duration _timeout = Duration(seconds: 10);

  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    final normalizedUsername = username.trim().toLowerCase();
    final normalizedPassword = password.trim();

    final uri = Uri.parse(_usersUrl);
    http.Response response;
    try {
      response = await http.get(uri).timeout(_timeout);
    } catch (_) {
      throw AuthException('Gagal terhubung ke API dummy.');
    }

    if (response.statusCode != 200) {
      throw AuthException('Gagal mengambil data user.');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = null;
    }

    if (decoded is! List) {
      throw AuthException('Response tidak valid.');
    }

    for (final entry in decoded) {
      if (entry is! Map<String, dynamic>) {
        continue;
      }

      final entryUsername = entry['username']?.toString().toLowerCase();
      final entryPassword = entry['password']?.toString();
      if (entryUsername == normalizedUsername &&
          entryPassword == normalizedPassword) {
        final token = base64UrlEncode(
          utf8.encode(
            '${entry['id'] ?? ''}:${DateTime.now().millisecondsSinceEpoch}',
          ),
        );

        return AuthSession.fromJson(<String, dynamic>{
          'id': entry['id'] ?? 0,
          'username': entry['username'] ?? '',
          'email': entry['email'] ?? '',
          'accessToken': token,
        });
      }
    }

    throw AuthException('Username atau password salah.');
  }
}
