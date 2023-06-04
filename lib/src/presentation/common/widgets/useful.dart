import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';

Widget userInput({focusNode, onChangedHandler, label, obscureText = false}) {
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
        focusNode: focusNode,
        onChanged: onChangedHandler,
        obscureText: obscureText,
        decoration: InputDecoration(
          fillColor: whiteColor,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400, width: 0.25),
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          // border:
          //     OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
      const SizedBox(
        height: 20,
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
      ),
    ),
  );
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

Widget primaryButton(
  BuildContext context,
  Function() onPressedHandler,
  String label, {
  horizontalPadding = 30.0,
  verticalPadding = 10.0,
}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
      ),
      onPressed: () => onPressedHandler(),
      child: Text(label));
}

Widget secondaryButton(
  BuildContext context,
  Function() onPressedHandler,
  String label, {
  horizontalPadding = 30.0,
  verticalPadding = 10.0,
}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        textStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
      ),
      onPressed: () => onPressedHandler(),
      child: Text(label));
}

Widget backButton() {
  return const Icon(Icons.keyboard_backspace_outlined,
      size: 30, color: blackColor);
}

Future<T?> showModalBottomSheetHandler<T>(
    BuildContext context, Widget Function(BuildContext) builder) {
  return showModalBottomSheet<T>(
      context: context, builder: builder, useRootNavigator: true);
}
