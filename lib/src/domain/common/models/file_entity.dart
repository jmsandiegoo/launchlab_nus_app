import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:launchlab/src/utils/extensions.dart';

abstract class FileEntity extends Equatable {
  const FileEntity({
    this.id,
    required this.userId,
    required this.file,
    this.signedUrl,
  });

  final String? id;
  final String userId;
  final File file;
  final String? signedUrl;

  String get fileName => file.name;
  String get fileIdentifier;

  FileEntity copyWith({
    String? id,
    String? userId,
    File? file,
    String? signedUrl,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'file_name': fileName,
      'file_identifier': fileIdentifier,
      'user_id': userId,
    };

    if (id != null) {
      json['id'] = id;
    }

    return json;
  }

  @override
  List<Object?> get props => [
        id,
        fileName,
        fileIdentifier,
        userId,
        file,
        signedUrl,
      ];
}
