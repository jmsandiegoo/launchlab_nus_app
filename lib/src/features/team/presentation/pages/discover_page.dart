import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Stack(children: [
          Image.asset("assets/images/yellow_rectangle.png"),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 70,
                ),
                Row(children: const [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Find Teams / Users",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ]),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextField(
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              hintText: 'Search',
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print("Click event on Container");
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.only(top: 8, bottom: 10),
                            decoration: BoxDecoration(
                                color: blackColor,
                                borderRadius: BorderRadius.circular(10)),
                            width: 50,
                            child: const Icon(
                              Icons.filter_alt,
                              color: Colors.yellow,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
        ]),
      ]),
    );
  }
}
