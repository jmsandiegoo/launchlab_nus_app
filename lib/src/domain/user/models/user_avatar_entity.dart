import 'dart:io';

import 'package:launchlab/src/domain/common/models/file_entity.dart';
import 'package:launchlab/src/utils/extensions.dart';

class UserAvatarEntity extends FileEntity {
  const UserAvatarEntity({
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
  String get fileIdentifier => "${userId}_avatar.${file.ext}";

  @override
  UserAvatarEntity copyWith({
    String? id,
    String? userId,
    File? file,
    String? signedUrl,
  }) {
    return UserAvatarEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      file: file ?? this.file,
      signedUrl: signedUrl ?? this.signedUrl,
    );
  }
}
