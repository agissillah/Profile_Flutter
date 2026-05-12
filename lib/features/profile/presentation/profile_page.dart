import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../domain/entities/profile.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  String _maskedToken(String token) {
    if (token.length <= 10) {
      return token;
    }

    final start = token.substring(0, 6);
    final end = token.substring(token.length - 4);
    return '$start...$end';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        Widget body;

        if (state is ProfileLoaded) {
          body = _ProfileContent(
            profile: state.profile,
            maskedToken: _maskedToken(state.profile.token),
          );
        } else if (state is ProfileError) {
          body = Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          );
        } else {
          body = const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile Pribadi'),
            centerTitle: true,
            actions: [
              TextButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(const LogoutRequested());
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: body,
        );
      },
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.profile,
    required this.maskedToken,
  });

  final Profile profile;
  final String maskedToken;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Column(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage(profile.avatarAssetPath),
              ),
              const SizedBox(height: 16),
              Text(
                profile.fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(profile.headline),
                backgroundColor: Colors.green.withValues(alpha: 0.2),
                labelStyle: const TextStyle(color: Colors.green),
              ),
              const SizedBox(height: 12),
              _InfoCard(
                icon: Icons.person,
                label: 'Username',
                value: profile.username.isEmpty ? '-' : profile.username,
              ),
              _InfoCard(
                icon: Icons.email,
                label: 'Email',
                value: profile.email.isEmpty ? '-' : profile.email,
              ),
              _InfoCard(
                icon: Icons.vpn_key,
                label: 'Token',
                value: maskedToken,
              ),
              _InfoCard(
                icon: Icons.school,
                label: 'Kampus',
                value: profile.campus,
              ),
              _InfoCard(
                icon: Icons.place,
                label: 'Lokasi',
                value: profile.location,
              ),
              _InfoCard(
                icon: Icons.code,
                label: 'Jurusan',
                value: profile.major,
              ),
              _InfoCard(
                icon: Icons.badge,
                label: 'NRP',
                value: profile.nrp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
