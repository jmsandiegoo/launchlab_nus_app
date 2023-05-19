import 'package:flutter/material.dart';

class RocketPage extends StatelessWidget {
  const RocketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Column(
            children: const [
              SizedBox(
                height: 200,
              ),
              Text("Rocket Page"),]
        )
    );
  }


}