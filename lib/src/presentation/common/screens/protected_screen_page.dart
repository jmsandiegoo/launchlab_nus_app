import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prototype/src/presentation/common/cubits/app_root_cubit.dart';

class ProtectedScreenPage extends StatelessWidget {
  const ProtectedScreenPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppRootCubit, AppRootState>(
      listener: (context, state) {
        if (!state.isSignedIn) {
          context.go("/signin");
        }
      },
      builder: (context, state) {
        return child;
      },
    );
  }
}
