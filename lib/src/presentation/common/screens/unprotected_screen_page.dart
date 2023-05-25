import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prototype/src/presentation/common/cubits/app_root_cubit.dart';

class UnprotectedScreenPage extends StatelessWidget {
  const UnprotectedScreenPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppRootCubit, AppRootState>(
      listener: (context, state) {
        if (state.isSignedIn) {
          context.go("/team-home");
        }
      },
      child: child,
    );
  }
}
