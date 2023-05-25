import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Column(
            children: const [
              SizedBox(
                height: 200,
              ),
              Text("Profile Page"),]
        )
    );
  }
}