import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prototype/src/presentation/common/cubits/splash_screen_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/authentication/repository/auth_repository.dart';
import '../cubits/app_root_cubit.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashScreenCubit(AuthRepository(Supabase.instance)),
      child: const SplashScreenContent(),
    );
  }
}

class SplashScreenContent extends StatefulWidget {
  const SplashScreenContent({super.key});

  @override
  State<SplashScreenContent> createState() => _SplashScreenContentState();
}

class _SplashScreenContentState extends State<SplashScreenContent> {
  late SplashScreenCubit _splashScreenCubit;
  late AppRootCubit _appRootCubit;

  @override
  void initState() {
    super.initState();
    _splashScreenCubit = BlocProvider.of<SplashScreenCubit>(context);
    _appRootCubit = BlocProvider.of<AppRootCubit>(context);

    // Check initial session when app loads
    Future.wait([Future.delayed(const Duration(milliseconds: 2000))]).then((_) {
      _splashScreenCubit.handleInitAuthSession();
      _appRootCubit.handleSessionChange(_splashScreenCubit.state.session);

      if (_splashScreenCubit.state.session == null) {
        context.go("/signin");
      } else {
        context.go("/team-home");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset("images/launchlab_logo.png"),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
