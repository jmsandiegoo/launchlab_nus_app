import 'package:equatable/equatable.dart';

class DownloadAvatarImageRequest extends Equatable {
  const DownloadAvatarImageRequest({
    required this.userId,
    this.isSignedUrlEnabled = false,
  });

  final String userId;
  final bool isSignedUrlEnabled;

  @override
  List<Object?> get props => [userId];
}
