import '../../domain/entities/profile.dart';
import '../../domain/entities/profile_input.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required ProfileLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final ProfileLocalDataSource _localDataSource;

  @override
  Future<Profile> getProfile(ProfileInput input) async {
    return _localDataSource.getProfile(input);
  }
}
