import 'package:flutter/foundation.dart';

import '../../domain/entities/profile.dart';

@immutable
sealed class ProfileState {
  const ProfileState();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.profile});

  final Profile profile;
}

final class ProfileError extends ProfileState {
  const ProfileError({required this.message});

  final String message;
}
