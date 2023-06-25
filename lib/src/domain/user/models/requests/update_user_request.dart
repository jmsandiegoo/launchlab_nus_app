import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class UpdateUserRequest extends Equatable {
  const UpdateUserRequest({
    required this.userProfile,
    this.userAvatar,
    this.userResume,
  });

  final File? userAvatar;
  final File? userResume;
  final UserEntity userProfile;

  @override
  List<Object?> get props => [userAvatar, userResume, userProfile];
}
