import 'package:equatable/equatable.dart';

class DownloadUserResumeRequest extends Equatable {
  const DownloadUserResumeRequest({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}
