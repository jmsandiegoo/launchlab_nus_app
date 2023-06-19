import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'constants.dart';

void navigateGo(BuildContext context, String dir) {
  context.go(dir);
}

Future<NavigationData<T>?> navigatePush<T>(
    BuildContext context, String dir) async {
  return await context.push(dir);
}

Future<NavigationData<T>?> navigatePushWithData<T>(
    BuildContext context, String dir, pushData) async {
  return await context.push(dir, extra: pushData);
}

void navigatePop(BuildContext context) {
  context.pop();
}

void navigatePopWithData<T>(
    BuildContext context, T? returnData, ActionTypes actionTypes) {
  context.pop(NavigationData<T>(data: returnData, actionType: actionTypes));
}

File? convertToFile(XFile? xFile) => xFile != null ? File(xFile.path) : null;

String dateStringFormatter(String pattern, DateTime date) {
  return DateFormat(pattern).format(date);
}

/// throws StorageException
Future<void> uploadFile({
  required Supabase supabase,
  required String bucket,
  required File file,
  required String fileIdentifier,
}) async {
  final fileExt = file.path.split('.').last;
  final fileName = '$fileIdentifier.$fileExt';
  final filePath = fileName;
  await supabase.client.storage.from(bucket).upload(
        filePath,
        file,
        fileOptions:
            FileOptions(contentType: lookupMimeType(fileExt), upsert: true),
      );
}
