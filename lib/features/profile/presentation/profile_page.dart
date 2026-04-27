import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.email, required this.token});

  final String email;
  final String token;

  String get _maskedToken {
    if (token.length <= 10) {
      return token;
    }

    final start = token.substring(0, 6);
    final end = token.substring(token.length - 4);
    return '$start...$end';
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Muhammad Aghiitsillah',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Chip(
                  label: const Text('Mahasiswa Teknik Informatika'),
                  backgroundColor: Colors.green.withValues(alpha: 0.2),
                  labelStyle: const TextStyle(color: Colors.green),
                ),
                const _InfoCard(
                  icon: Icons.school,
                  label: 'Kampus',
                  value: 'PENS PSDKU Lamongan',
                ),
                const _InfoCard(
                  icon: Icons.place,
                  label: 'Lokasi',
                  value: 'Lamongan, Jawa Timur',
                ),
                const _InfoCard(
                  icon: Icons.code,
                  label: 'Jurusan',
                  value: 'Teknik Informatika',
                ),
                const _InfoCard(
                  icon: Icons.badge,
                  label: 'NRP',
                  value: '3124521028',
                ),
              ],
            ),
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
