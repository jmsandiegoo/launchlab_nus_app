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

extension MoveElement<T> on List<T> {
  void move(int from, int to) {
    RangeError.checkValidIndex(from, this, "from", length);
    RangeError.checkValidIndex(to, this, "to", length);
    var element = this[from];
    if (from < to) {
      setRange(from, to, this, from + 1);
    } else {
      setRange(to + 1, from + 1, this, to);
    }
    this[to] = element;
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
