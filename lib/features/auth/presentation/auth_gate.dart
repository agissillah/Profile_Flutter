import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          return ProfilePage(email: state.email, token: state.token);
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
