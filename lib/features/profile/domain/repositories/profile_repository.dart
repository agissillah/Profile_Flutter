import '../entities/profile.dart';
import '../entities/profile_input.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile(ProfileInput input);
}
