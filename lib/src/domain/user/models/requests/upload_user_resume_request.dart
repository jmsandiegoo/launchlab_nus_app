import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/user_resume_entity.dart';

class UploadUserResumeRequest extends Equatable {
  const UploadUserResumeRequest({required this.userResume});

  final UserResumeEntity userResume;

  @override
  List<Object?> get props => [userResume];
}
