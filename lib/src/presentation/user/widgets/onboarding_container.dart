import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_container_cubit.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingContainer extends StatelessWidget {
  const OnboardingContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => OnboardingCubit(
            CommonRepository(Supabase.instance),
            UserRepository(
              Supabase.instance,
            )),
        child: BlocBuilder<AppRootCubit, AppRootState>(
          builder: (context, state) => child,
        ));
  }
}
