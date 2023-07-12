import 'dart:io';

extension FileExtension on File {
  String get name {
    return path.split(Platform.pathSeparator).last;
  }

  String get ext {
    return path.split('.').last;
  }
}

extension StringExtension on String {
  String toCapitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
