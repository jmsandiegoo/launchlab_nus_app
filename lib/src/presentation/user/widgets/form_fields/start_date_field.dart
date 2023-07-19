import 'package:formz/formz.dart';

class StartDateFieldInput extends FormzInput<DateTime?, StartDateFieldError> {
  const StartDateFieldInput.unvalidated([DateTime? value]) : super.pure(value);
  const StartDateFieldInput.validated([DateTime? value]) : super.dirty(value);

  @override
  StartDateFieldError? validator(DateTime? value) {
    if (value == null) {
      return StartDateFieldError.empty;
    }

    return null;
  }
}

enum StartDateFieldError {
  empty,
}

extension StartDateFieldErrorExt on StartDateFieldError {
  String text() {
    switch (this) {
      case StartDateFieldError.empty:
        return "Start Date required";
    }
  }
}
