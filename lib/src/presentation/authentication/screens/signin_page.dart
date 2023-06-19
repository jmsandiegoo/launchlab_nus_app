import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/presentation/authentication/cubits/signin_cubit.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
            body: Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                Center(child: Image.asset("assets/images/launchlab_logo.png")),
                Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: secondaryButton(context, () {
                    BlocProvider.of<SigninCubit>(context)
                        .handleSigninWithGoogle();
                  }, "",
                      childBuilder: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          profilePicture(20.0, "assets/images/google_logo.png"),
                          Text(
                            "   Sign in with Google",
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          ),
                        ],
                      ),
                      isLoading: state is SigninLoading),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
