import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:launchlab/src/utils/helper.dart';

class ProtectedScreenPage extends StatelessWidget {
  const ProtectedScreenPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppRootCubit, AppRootState>(
      listener: (context, state) {
        if (state.appRootStateStatus == AppRootStateStatus.loading ||
            state.appRootStateStatus == AppRootStateStatus.error) {
          return;
        }

        if (!state.isSignedIn) {
          navigateGo(context, "/signin");
        }

        if (state.authUserProfile != null &&
            !state.authUserProfile!.isOnboarded &&
            GoRouterState.of(context).uri.toString().startsWith("/onboard")) {
          navigateGo(context, "/onboard");
        }
      },
      builder: (context, state) {
        return child;
      },
    );
  }
}
