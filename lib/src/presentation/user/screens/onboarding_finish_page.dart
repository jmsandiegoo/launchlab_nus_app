import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class OnboardingFinishPage extends StatelessWidget {
  const OnboardingFinishPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppRootCubit appRootCubit = BlocProvider.of<AppRootCubit>(context);
    return BlocConsumer<AppRootCubit, AppRootState>(
      listener: (context, state) {
        if (state.appRootStateStatus == AppRootStateStatus.success) {
          navigateGo(context, "/team-home");
        }
      },
      builder: (context, state) => Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 290,
                height: 190,
                child: Image.asset("assets/images/onboard_finish.png"),
              ),
              const SizedBox(
                height: 25.0,
              ),
              headerText(
                  "Congrats your are now ready \n to use the application!",
                  alignment: TextAlign.center),
              const SizedBox(
                height: 50.0,
              ),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 170.0),
                  width: double.infinity,
                  child: primaryButton(
                    context,
                    () {
                      debugPrint('great btn pressed');
                      appRootCubit.handleGetAuthUserProfile();
                    },
                    "Great!",
                    elevation: 0,
                    isLoading:
                        state.appRootStateStatus == AppRootStateStatus.loading,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
