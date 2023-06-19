import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';

Widget userInput({
  required FocusNode focusNode,
  required void Function(String) onChangedHandler,
  required String label,
  bool obscureText = false,
  int size = 1,
  String hint = "",
  bool isEnabled = true,
  bool isReadOnly = false,
  void Function()? onTapHandler,
  Widget? suffixWidget,
  TextEditingController? controller,
  String? errorText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ...() {
        if (label == "") {
          return [];
        }
        return [
          Text(
            label,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(
            height: 5,
          )
        ];
      }(),
      TextField(
        enabled: isEnabled,
        readOnly: isReadOnly,
        focusNode: focusNode,
        controller: controller,
        onChanged: onChangedHandler,
        onTap: onTapHandler,
        keyboardType: size > 1 ? TextInputType.multiline : null,
        minLines: size,
        maxLines: size,
        obscureText: obscureText,
        decoration: InputDecoration(
          errorText: errorText,
          suffixIcon: suffixWidget,
          hintText: hint,
          fillColor: isEnabled ? whiteColor : greyColor.shade300,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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

Widget checkBox(String label, bool? value, bool tristate,
    void Function(bool?) onChangedHandler) {
  return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
    Checkbox(
      tristate: tristate,
      value: value,
      onChanged: onChangedHandler,
      checkColor: blackColor,
      fillColor: const MaterialStatePropertyAll(yellowColor),
      side: const BorderSide(width: 0.5),
      activeColor: whiteColor,
    ),
    bodyText(label),
  ]);
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

Widget smallText(String label,
    {size = 13.0,
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
  double? elevation,
  bool isLoading = false,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: elevation,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
    ),
    onPressed: () {
      if (isLoading) {
        return;
      }

      onPressedHandler();
    },
    child: isLoading
        ? SizedBox(
            height: 17,
            width: 17,
            child: CircularProgressIndicator(
                strokeWidth: 1, color: Theme.of(context).colorScheme.onPrimary),
          )
        : Text(label),
  );
}

Widget secondaryButton(
  BuildContext context,
  Function() onPressedHandler,
  String label, {
  horizontalPadding = 30.0,
  verticalPadding = 10.0,
  double? elevation,
  bool isLoading = false,
  Widget? childBuilder,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: elevation,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
    ),
    onPressed: () {
      if (isLoading) {
        return;
      }
      onPressedHandler();
    },
    child: isLoading
        ? SizedBox(
            height: 17,
            width: 17,
            child: CircularProgressIndicator(
                strokeWidth: 1,
                color: Theme.of(context).colorScheme.onSecondary),
          )
        : childBuilder ??
            Text(
              label,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            ),
  );
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

Widget chip<T>(label, T value, {void Function(T value)? onDeleteHandler}) {
  return Chip(
      labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
      label: bodyText(label),
      backgroundColor: Colors.transparent,
      deleteIcon: const Icon(
        Icons.close_outlined,
        size: 20.0,
        weight: 300,
      ),
      deleteIconColor: blackColor,
      onDeleted: onDeleteHandler == null ? null : () => onDeleteHandler(value),
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.5),
          borderRadius: BorderRadius.circular(10.0)));
}

Widget chipsWrap<T>(List<T> items, {void Function(T value)? onDeleteHandler}) {
  return Wrap(
    runSpacing: 5.0,
    spacing: 5.0,
    children: items
        .map((item) =>
            chip(item.toString(), item, onDeleteHandler: onDeleteHandler))
        .toList(),
  );
}
