import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/presentation/auth_gate.dart';
import 'features/profile/data/datasources/profile_local_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRemoteDataSource>(
          create: (_) => AuthRemoteDataSourceImpl(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSource>(),
          ),
        ),
        RepositoryProvider<ProfileLocalDataSource>(
          create: (_) => ProfileLocalDataSourceImpl(),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepositoryImpl(
            localDataSource: context.read<ProfileLocalDataSource>(),
          ),
        ),
      ],
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          login: LoginUseCase(context.read<AuthRepository>()),
          logout: LogoutUseCase(context.read<AuthRepository>()),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.green,
            brightness: Brightness.dark,
          ),
          home: const AuthGate(),
        ),
      ),
    );
  }
}
