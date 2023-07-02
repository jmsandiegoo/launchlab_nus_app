import 'package:equatable/equatable.dart';

class DeleteUserAvatarResumeRequest extends Equatable {
  const DeleteUserAvatarResumeRequest({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}
