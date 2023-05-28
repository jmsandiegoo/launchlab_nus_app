import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

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
          Image.asset("assets/images/yellow_curve_shape_3.png"),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Row(children: [
                  const SizedBox(width: 20),
                  headerText("Find Teams / Users"),
                ]),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        searchBar(),
                        InkWell(
                          onTap: () {
                            //Go to advance page search here
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.only(top: 8, bottom: 10),
                            decoration: BoxDecoration(
                                color: blackColor,
                                borderRadius: BorderRadius.circular(10)),
                            width: 50,
                            child: const Icon(
                              Icons.filter_alt_outlined,
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
