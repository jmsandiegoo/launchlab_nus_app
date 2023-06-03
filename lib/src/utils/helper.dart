import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

void navigateGo(BuildContext context, String dir) {
  context.go(dir);
}

void navigatePush(BuildContext context, String dir) {
  context.push(dir);
}

void navigatePop(BuildContext context) {
  context.pop();
}

File? convertToFile(XFile? xFile) => xFile != null ? File(xFile.path) : null;
