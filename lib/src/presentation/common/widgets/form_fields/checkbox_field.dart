import 'package:formz/formz.dart';

class CheckboxFieldInput extends FormzInput<bool, CheckboxFieldError> {
  const CheckboxFieldInput.unvalidated([bool value = false])
      : super.pure(value);
  const CheckboxFieldInput.validated([bool value = false]) : super.dirty(value);
  @override
  CheckboxFieldError? validator(bool value) {
    return null;
  }
}

enum CheckboxFieldError {
  none,
}
