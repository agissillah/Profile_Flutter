import '../../domain/entities/auth_session.dart';
import '../../domain/errors/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    try {
      return await _remoteDataSource.login(
        username: username,
        password: password,
      );
    } on AuthRemoteException catch (error) {
      throw AuthFailure(error.message);
    } catch (_) {
      throw const AuthFailure('Terjadi kesalahan tidak terduga.');
    }
  }

  @override
  Future<void> logout() async {}
}
