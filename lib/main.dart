import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prototype/src/config/app_config.dart';
import 'package:prototype/src/config/app_router.dart';
import 'package:prototype/src/config/app_theme.dart';
import 'package:prototype/src/data/authentication/repository/auth_repository.dart';
import 'package:prototype/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseToken,
  );

  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppRootCubit(AuthRepository(Supabase.instance)),
      child: const RootAppContent(),
    );
  }
}

class RootAppContent extends StatelessWidget {
  const RootAppContent({super.key});

  @override
  Widget build(BuildContext context) {
    final appRootCubit = BlocProvider.of<AppRootCubit>(context);

    // Susbcribe to Auth
    appRootCubit.handleAuthListener();

    return MaterialApp.router(
      theme: appThemeData,
      routerConfig: appRouter,
    );
  }
}
