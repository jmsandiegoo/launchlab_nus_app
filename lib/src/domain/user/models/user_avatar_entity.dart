import 'dart:io';

import 'package:launchlab/src/domain/common/models/file_entity.dart';
import 'package:launchlab/src/utils/extensions.dart';

class UserAvatarEntity extends FileEntity {
  const UserAvatarEntity({
    String? id,
    required this.userId,
    required File file,
    String? signedUrl,
  }) : super(
          id: id,
          file: file,
          signedUrl: signedUrl,
        );

  final String userId;

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

  @override
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
}
