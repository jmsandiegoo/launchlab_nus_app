import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:launchlab/src/config/app_theme.dart';

Widget userInput({label, obsureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obsureText,
        decoration: const InputDecoration(
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
      const SizedBox(
        height: 30,
      )
    ],
  );
}

Widget profilePicture(double diameter, String address) {
  return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: ExactAssetImage(address),
            fit: BoxFit.fitHeight,
          )));
}

Widget searchBar() {
  return Flexible(
    flex: 1,
    child: TextField(
      cursorColor: greyColor,
      decoration: InputDecoration(
        fillColor: whiteColor,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        hintText: 'Search',
        hintStyle: const TextStyle(color: greyColor, fontSize: 13),
      ),
    ),
  );
}

Widget headerText(String label, {size = 25.0, alignment = TextAlign.left}) {
  return Text(
    label,
    textAlign: alignment,
    style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
  );
}

Widget subHeaderText(String label, {size = 20.0, alignment = TextAlign.left}) {
  return Text(
    label,
    textAlign: alignment,
    style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
  );
}

Widget bodyText(String label,
    {size = 15.0,
    color = blackColor,
    weight = FontWeight.w400,
    alignment = TextAlign.left}) {
  return Text(
    label,
    textAlign: alignment,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontWeight: weight,
    ),
  );
}

Widget backButton() {
  return const Icon(Icons.arrow_back, size: 30, color: blackColor);
}

void navigateGo(BuildContext context, String dir) {
  context.go(dir);
}

void navigatePush(BuildContext context, String dir) {
  context.push(dir);
}
