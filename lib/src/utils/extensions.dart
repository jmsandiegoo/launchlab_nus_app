import 'dart:io';

extension FileExtension on File {
  String get name {
    return path.split(Platform.pathSeparator).last;
  }

  String get ext {
    return path.split('.').last;
  }
}
