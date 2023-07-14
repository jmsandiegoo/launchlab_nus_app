import 'dart:io';

/// File extension
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

/// DateTime extension
extension DateTimeTimeExtension on DateTime {
  /// return true if input date is same
  bool isSameDate(DateTime inputDate) {
    return year == inputDate.year &&
        month == inputDate.month &&
        day == inputDate.day;
  }

  bool isSameYear(DateTime inputDate) {
    return year == inputDate.year;
  }
}
