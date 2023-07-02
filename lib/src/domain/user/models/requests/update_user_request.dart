import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class UpdateUserRequest extends Equatable {
  const UpdateUserRequest({required this.userProfile});

  final UserEntity userProfile;

  @override
  List<Object?> get props => [userProfile];
}
