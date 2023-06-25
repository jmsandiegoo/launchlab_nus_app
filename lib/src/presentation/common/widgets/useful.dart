import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:launchlab/src/presentation/common/widgets/confirmation_box.dart';

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
  TextInputType keyboard = TextInputType.multiline,
  bool endSpacing = true,
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
        keyboardType: size > 1 ? keyboard : null,
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
      endSpacing ? const SizedBox(height: 20) : const SizedBox()
    ],
  );
}

Widget userInput_2({
  label,
  obsureText = false,
  controller,
  size = 1,
  hint = "",
  keyboard = TextInputType.multiline,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: blackColor),
      ),
      const SizedBox(height: 5),
      TextField(
        keyboardType: keyboard,
        minLines: size, //Normal textInputField will be displayed
        maxLines: size,
        obscureText: obsureText,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15.0, color: greyColor),
          filled: true,
          fillColor: whiteColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: lightGreyColor,
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

Widget profilePicture(double diameter, String address, {bool isUrl = false}) {
  return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: isUrl
                ? Image.network(address).image
                : ExactAssetImage("assets/images/$address"),
            fit: BoxFit.cover,
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
    maxLines: 2,
    textAlign: alignment,
    style: TextStyle(
        fontSize: size, fontWeight: FontWeight.bold, color: blackColor),
  );
}

Widget subHeaderText(String label,
    {size = 20.0, alignment = TextAlign.left, color = blackColor}) {
  return Text(
    label,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    textAlign: alignment,
    style: TextStyle(fontSize: size, fontWeight: FontWeight.bold, color: color),
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

Widget outlinedButton({
  required String label,
  required void Function() onPressedHandler,
  required Color color,
  bool isLoading = false,
}) {
  return OutlinedButton(
      onPressed: () {
        if (isLoading) {
          return;
        }

        onPressedHandler();
      },
      style: OutlinedButton.styleFrom(side: BorderSide(color: color)),
      child: isLoading
          ? SizedBox(
              height: 17,
              width: 17,
              child: CircularProgressIndicator(strokeWidth: 1, color: color),
            )
          : bodyText(label, color: color));
}

Widget overflowText(String label,
    {size = 15.0, color = blackColor, maxLines = 3}) {
  return Text(
    label,
    maxLines: maxLines,
    softWrap: true,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(fontSize: size, color: color),
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

Widget boldFirstText(String text1, String text2, {size = 12.5}) {
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
              width: 100,
              height: 100,
              child: outerCircleBar(total == 0 ? 0 : current / total)),
          SizedBox(
            height: 100,
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                subHeaderText(
                    "${total == 0 ? 0 : (current / total * 100).round()}%",
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

void applicationConfirmationBox(context, title, message) {
  showDialog(
    context: context,
    builder: (context) {
      return ConfirmationBox(
        title: title,
        message: message,
        onClose: () => Navigator.pop(context),
      );
    },
  );
}

String stringToDateFormatter(date) {
  final formatter = DateFormat('dd MMM yyyy');
  return formatter.format(DateTime.parse(date));
}

String dateToDateFormatter(date) {
  String formattedDate = DateFormat('dd MMM yyyy').format(date);
  return formattedDate;
}

Widget futureBuilderFail() {
  return Center(
      child: bodyText('Please ensure that you have internet connection'));
}

Widget chip<T>(label, T value, {void Function(T value)? onDeleteHandler}) {
  return Chip(
      labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
      label: smallText(label, size: 11.5),
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
    spacing: 5.0,
    children: items
        .map((item) =>
            chip(item.toString(), item, onDeleteHandler: onDeleteHandler))
        .toList(),
  );
}
