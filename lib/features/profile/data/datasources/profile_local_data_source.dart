import '../../domain/entities/profile_input.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  ProfileModel getProfile(ProfileInput input);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  ProfileModel getProfile(ProfileInput input) {
    return ProfileModel.fromInput(input);
  }
}
