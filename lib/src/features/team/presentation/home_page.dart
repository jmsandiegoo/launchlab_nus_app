import 'package:flutter/material.dart';
import 'package:prototype/src/shared/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: <Widget>[
              Image.asset("images/yellow_curve_shape.png"),
              AppBar(
                elevation: 0,
                backgroundColor: yellowTheme,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: Colors.black,
                    )),
              ),
              const Positioned(
                top: 175,
                left: 20,
                child: Text("Homepage",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          //Input the 2 buttons
        ]),
      ),
    );
  }
}
