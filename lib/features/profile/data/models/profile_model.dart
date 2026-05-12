import '../../domain/entities/profile.dart';
import '../../domain/entities/profile_input.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.fullName,
    required super.headline,
    required super.campus,
    required super.location,
    required super.major,
    required super.nrp,
    required super.avatarAssetPath,
    required super.username,
    required super.email,
    required super.token,
  });

  factory ProfileModel.fromInput(ProfileInput input) {
    return ProfileModel(
      fullName: 'Muhammad Aghiitsillah',
      headline: 'Mahasiswa Teknik Informatika',
      campus: 'PENS PSDKU Lamongan',
      location: 'Lamongan, Jawa Timur',
      major: 'Teknik Informatika',
      nrp: '3124521028',
      avatarAssetPath: 'assets/profile.jpg',
      username: input.username,
      email: input.email,
      token: input.token,
    );
  }
}
