import 'package:flutter/material.dart';
import 'package:prototype/sign_up_page.dart';
import 'package:prototype/res/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: yellowTheme,
        body: Column(children: [
          const SizedBox(
            height: 150,
          ),
          Center(
              child: Image.asset("images/launchlab_logo.png")
          ),

          ElevatedButton(
              child: const Text(
                'Navigate to the sign up page',
                style: TextStyle(fontSize: 24.0),
              ),
              onPressed: () {
                _navigateToSignUpPage(context);
              }),

          const SizedBox(
            height: 100,
          ),
          const Text("Need to do Auth here")
        ])
    );
  }

  void _navigateToSignUpPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignUpPage()));
  }
}
