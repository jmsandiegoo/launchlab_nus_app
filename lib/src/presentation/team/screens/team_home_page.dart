import 'package:flutter/material.dart';

class TeamHomePage extends StatefulWidget {
  const TeamHomePage({Key? key}) : super(key: key);

  @override
  State<TeamHomePage> createState() => _TeamHomePageState();
}

class _TeamHomePageState extends State<TeamHomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Stack(
          children: <Widget>[
            Image.asset("images/yellow_curve_shape.png"),
            AppBar(
              elevation: 0,
              // leading: IconButton(
              //     // onPressed: () {
              //     //   Navigator.pop(context);
              //     // },
              //     icon: const Icon(
              //       Icons.arrow_back_ios,
              //       size: 20,
              //       color: Colors.black,
              //     )),
            ),
            const Positioned(
              top: 175,
              left: 20,
              child: Text("Homepage",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        //Input the 2 buttons
      ]),
    );
  }
}
