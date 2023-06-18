import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void navigateGo(BuildContext context, String dir) {
  context.go(dir);
}

void navigatePush(BuildContext context, String dir) {
  GoRouter.of(context).push(dir);
}

Future<Object?> navigatePushData(BuildContext context, String dir, data) {
  return GoRouter.of(context).push(dir, extra: data);
}

void navigatePop(BuildContext context) {
  context.pop();
}

void navigatePopData(BuildContext context, data) {
  context.pop(data);
}

File? convertToFile(XFile? xFile) => xFile != null ? File(xFile.path) : null;

String dateStringFormatter(String pattern, DateTime date) {
  return DateFormat(pattern).format(date);
}
