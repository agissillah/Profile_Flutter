import 'auth_api_service.dart';

class AuthRepository {
  AuthRepository(this._apiService);

  final AuthApiService _apiService;

  Future<String> login({required String email, required String password}) {
    return _apiService.login(email: email, password: password);
  }
}
