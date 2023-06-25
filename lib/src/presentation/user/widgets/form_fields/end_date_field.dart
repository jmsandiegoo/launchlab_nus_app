import 'package:formz/formz.dart';

class EndDateFieldInput extends FormzInput<DateTime?, EndDateFieldError> {
  const EndDateFieldInput.unvalidated({this.isPresent = false, DateTime? value})
      : startDateFieldVal = null,
        super.pure(value);
  const EndDateFieldInput.validated({
    required this.isPresent,
    required this.startDateFieldVal,
    DateTime? value,
  }) : super.dirty(value);

  final bool isPresent;
  final DateTime? startDateFieldVal;

  @override
  EndDateFieldError? validator(DateTime? value) {
    if (value == null && !isPresent) {
      return EndDateFieldError.empty;
    }
    if (value != null && startDateFieldVal != null) {
      print(value.compareTo(startDateFieldVal!));
    }

    if (value != null &&
        startDateFieldVal != null &&
        value.compareTo(startDateFieldVal!) < 0) {
      return EndDateFieldError.invalid;
    }

    return null;
  }
}

enum EndDateFieldError { empty, invalid }

extension EndDateFieldErrorExt on EndDateFieldError {
  // ignore: unused_element
  String text() {
    switch (this) {
      case EndDateFieldError.empty:
        return "End Date is required";
      case EndDateFieldError.invalid:
        return "End Date is earlier";
    }
  }
}
