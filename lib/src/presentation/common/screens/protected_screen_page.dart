import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:launchlab/src/utils/helper.dart';

class ProtectedScreenPage extends StatelessWidget {
  const ProtectedScreenPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppRootCubit, AppRootState>(
      listener: (context, state) {
        print("listening");
        if (!state.isSignedIn) {
          navigateGo(context, "/signin");
        }
      },
      builder: (context, state) {
        return child;
      },
    );
  }
}
