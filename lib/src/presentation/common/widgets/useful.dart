import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:launchlab/src/config/app_theme.dart';

Widget userInput({label, obsureText = false, controller, size = 1, hint = ""}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: blackColor),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        keyboardType: TextInputType.multiline,
        minLines: size, //Normal textInputField will be displayed
        maxLines: size,
        obscureText: obsureText,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15.0, color: greyColor),
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
      const SizedBox(height: 30)
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
            image: ExactAssetImage("assets/images/$address"),
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

Widget bodyText(String label, {size = 15.0, color = blackColor}) {
  return Text(
    label,
    style: TextStyle(fontSize: size, color: color),
  );
}

Widget backButton() {
  return const Icon(Icons.arrow_back, size: 30, color: blackColor);
}

Widget boldFirstText(String text1, String text2, {size = 12.0}) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: size,
        color: Colors.black,
      ),
      children: <TextSpan>[
        TextSpan(
            text: text1, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: text2),
      ],
    ),
  );
}

Widget boldSecondText(String text1, String text2, {size = 12.0}) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: size,
        color: Colors.black,
      ),
      children: <TextSpan>[
        TextSpan(text: text1),
        TextSpan(
            text: text2, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Widget outerCircleBar(double progress) {
  return CircularProgressIndicator(
    strokeWidth: 3,
    backgroundColor: Colors.grey[350],
    valueColor: const AlwaysStoppedAnimation<Color>(yellowColor),
    value: progress,
  );
}

Widget circleProgressBar(current, total) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(children: [
          SizedBox(
              width: 100, height: 100, child: outerCircleBar(current / total)),
          SizedBox(
            height: 100,
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                subHeaderText("${(current / total * 100).round()}%",
                    size: 20.0),
                const SizedBox(height: 4),
                bodyText('$current / $total', color: darkGreyColor, size: 12.0),
                bodyText("Milestones", color: darkGreyColor, size: 12.0),
              ],
            ),
          ),
        ]),
      ],
    ),
  );
}

Widget memberProfile(imgDir, name, position,
    {imgSize = 30.0, textSize = 12.0, isBold = false}) {
  return Column(children: [
    const SizedBox(height: 7),
    Row(children: [
      profilePicture(imgSize, imgDir),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        isBold
            ? subHeaderText(name, size: textSize)
            : bodyText(name, size: textSize),
        bodyText(position, color: darkGreyColor, size: textSize)
      ])
    ])
  ]);
}

Widget manageMemberBar(imgDir, name, position) {
  return Column(children: [
    const SizedBox(height: 20),
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 3,
              offset: const Offset(0, 3),
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          memberProfile(imgDir, name, position, imgSize: 35.0, isBold: true),
          const SizedBox(height: 7),
        ]),
      ),
    ),
  ]);
}

Widget taskBar(taskName, isChecked, checkBox) {
  return Container(
    decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 3,
            offset: const Offset(0, 3),
          )
        ]),
    child: Row(
      children: [
        checkBox,
        // task name
        Text(
          taskName,
          style: TextStyle(
            decoration:
                isChecked ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
      ],
    ),
  );
}

void navigateGo(BuildContext context, String dir) {
  context.go(dir);
}

void navigatePush(BuildContext context, String dir) {
  context.push(dir);
}
