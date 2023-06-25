import 'package:equatable/equatable.dart';

class DownloadAvatarImageRequest extends Equatable {
  const DownloadAvatarImageRequest({
    required this.fileName,
  });

  final String fileName;

  @override
  List<Object?> get props => [fileName];
}
