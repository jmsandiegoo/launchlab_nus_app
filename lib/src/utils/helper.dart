import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:launchlab/src/domain/common/models/file_entity.dart';
import 'package:launchlab/src/utils/extensions.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
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
  required FileEntity uploadFile,
}) async {
  await supabase.client.storage.from(bucket).upload(
        uploadFile.fileIdentifier,
        uploadFile.file,
        fileOptions: FileOptions(
            contentType: lookupMimeType(uploadFile.file.ext), upsert: true),
      );
}

Future<void> deleteFile({
  required Supabase supabase,
  required String bucket,
  required String fileIdentifier,
}) async {
  await supabase.client.storage.from(bucket).remove([fileIdentifier]);
}

Future<File> downloadFile({
  required Supabase supabase,
  required String bucket,
  required String fileIdentifier,
  required String fileName,
}) async {
  final Uint8List downloadedFile =
      await supabase.client.storage.from(bucket).download(fileIdentifier);

  final tempDir = await getTemporaryDirectory();
  File file = await File('${tempDir.path}/$fileName').create();
  file.writeAsBytesSync(downloadedFile);
  return file;
}
