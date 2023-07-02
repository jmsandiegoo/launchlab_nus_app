import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';

class UploadUserAvatarRequest extends Equatable {
  const UploadUserAvatarRequest({required this.userAvatar});

  final UserAvatarEntity userAvatar;

  @override
  List<Object?> get props => [userAvatar];
}
