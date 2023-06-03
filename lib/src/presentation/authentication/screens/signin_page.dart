import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/authentication/repository/auth_repository.dart';
import '../cubits/signin_cubit.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SigninCubit(AuthRepository(Supabase.instance)),
      child: BlocBuilder<SigninCubit, SigninState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.primary,
              body: Column(children: [
                const SizedBox(
                  height: 150,
                ),
                Center(child: Image.asset("assets/images/launchlab_logo.png")),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 75.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.secondary)),
                    child: state is SigninLoading
                        ? const CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              profilePicture(
                                  20.0, "assets/images/google_logo.png"),
                              const Text("   Sign in with Google"),
                            ],
                          ),
                    onPressed: () {
                      BlocProvider.of<SigninCubit>(context)
                          .handleSigninWithGoogle();
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      navigateGo(context, "/team-home");
                    },
                    child: const Text("bypass")),
                const SizedBox(
                  height: 100,
                ),
              ]));
        },
      ),
    );
  }
}
