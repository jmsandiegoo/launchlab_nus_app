import 'dart:io';

import 'package:launchlab/src/domain/common/models/file_entity.dart';
import 'package:launchlab/src/utils/extensions.dart';

class UserResumeEntity extends FileEntity {
  const UserResumeEntity({
    String? id,
    required String userId,
    required File file,
    String? signedUrl,
  }) : super(
          id: id,
          userId: userId,
          file: file,
          signedUrl: signedUrl,
        );

  @override
  String get fileIdentifier => "${userId}_resume.${file.ext}";

  @override
  UserResumeEntity copyWith({
    String? id,
    String? userId,
    File? file,
    String? signedUrl,
  }) {
    return UserResumeEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      file: file ?? this.file,
      signedUrl: signedUrl ?? this.signedUrl,
    );
  }
}
