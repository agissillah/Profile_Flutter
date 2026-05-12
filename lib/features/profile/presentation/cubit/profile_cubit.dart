import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/profile_input.dart';
import '../../domain/usecases/get_profile.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required GetProfileUseCase getProfile,
    required ProfileInput input,
  })  : _getProfile = getProfile,
        super(const ProfileLoading()) {
    _load(input);
  }

  final GetProfileUseCase _getProfile;

  Future<void> _load(ProfileInput input) async {
    try {
      final profile = await _getProfile(input);
      emit(ProfileLoaded(profile: profile));
    } catch (_) {
      emit(const ProfileError(message: 'Gagal memuat profil.'));
    }
  }
}
