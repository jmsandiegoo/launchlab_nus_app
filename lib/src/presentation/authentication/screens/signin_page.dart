import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prototype/src/data/authentication/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
              body: Column(children: [
            const SizedBox(
              height: 150,
            ),
            Center(child: Image.asset("images/launchlab_logo.png")),
            ElevatedButton(
                child: const Text(
                  'Sign in with Google',
                ),
                onPressed: () {
                  BlocProvider.of<SigninCubit>(context)
                      .handleSigninWithGoogle();
                }),
            const SizedBox(
              height: 100,
            ),
            const Text("Need to do Auth here")
          ]));
        },
      ),
    );
  }
}
