import 'auth_api_service.dart';
import 'auth_session.dart';

class AuthRepository {
  AuthRepository(this._apiService);

  final AuthApiService _apiService;

  Future<AuthSession> login({
    required String username,
    required String password,
  }) {
    return _apiService.login(username: username, password: password);
  }
}
