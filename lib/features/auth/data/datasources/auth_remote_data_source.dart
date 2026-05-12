import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/auth_session_model.dart';

class AuthRemoteException implements Exception {
  AuthRemoteException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> login({
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const String _usersUrl =
      'https://raw.githubusercontent.com/Ovi/DummyJSON/master/database/users.json';
  static const Duration _timeout = Duration(seconds: 10);

  @override
  Future<AuthSessionModel> login({
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
      throw AuthRemoteException('Gagal terhubung ke API dummy.');
    }

    if (response.statusCode != 200) {
      throw AuthRemoteException('Gagal mengambil data user.');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = null;
    }

    if (decoded is! List) {
      throw AuthRemoteException('Response tidak valid.');
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

        return AuthSessionModel.fromJson(<String, dynamic>{
          'id': entry['id'] ?? 0,
          'username': entry['username'] ?? '',
          'email': entry['email'] ?? '',
          'accessToken': token,
        });
      }
    }

    throw AuthRemoteException('Username atau password salah.');
  }
}
