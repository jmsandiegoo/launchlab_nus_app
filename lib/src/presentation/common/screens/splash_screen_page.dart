import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:launchlab/src/presentation/common/cubits/splash_screen_cubit.dart';
import 'package:launchlab/src/utils/helper.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

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
    Future.wait([_splashScreenCubit.handleInitAuthSession()]).then((_) {
      print('executed: ${_splashScreenCubit.state.session}');
      _appRootCubit.handleSessionChange(
        session: _splashScreenCubit.state.session,
        authUserProfile: _splashScreenCubit.state.authUserProfile,
      );

      if (_splashScreenCubit.state.session == null) {
        navigateGo(context, "/signin");
      } else {
        if (_appRootCubit.state.authUserProfile!.isOnboarded) {
          navigateGo(context, "/team-home");
        } else {
          navigateGo(context, "/onboard");
        }
      }
    }).catchError((_) {
      navigateGo(context, "/signin");
    });
  }

  @override
  Widget build(BuildContext context) {
    print("splashscreen");
    return Scaffold(
        backgroundColor: yellowColor,
        body: Center(
          child: Column(
            children: [
              Image.asset("assets/images/launchlab_logo.png"),
              const CircularProgressIndicator(color: blackColor),
            ],
          ),
        ));
  }
}
