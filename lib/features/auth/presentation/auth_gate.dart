import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../profile/domain/entities/profile_input.dart';
import '../../profile/domain/repositories/profile_repository.dart';
import '../../profile/domain/usecases/get_profile.dart';
import '../../profile/presentation/cubit/profile_cubit.dart';
import '../../profile/presentation/profile_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final input = ProfileInput(
            username: state.session.username,
            email: state.session.email,
            token: state.session.token,
          );

          return BlocProvider(
            create: (context) => ProfileCubit(
              getProfile: GetProfileUseCase(
                context.read<ProfileRepository>(),
              ),
              input: input,
            ),
            child: const ProfilePage(),
          );
        }

        return LoginPage(
          isLoading: state is AuthLoading,
          errorMessage: state is AuthUnauthenticated
              ? state.errorMessage
              : null,
        );
      },
    );
  }
}
