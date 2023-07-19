import 'package:formz/formz.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';

class DegreeProgrammeFieldInput
    extends FormzInput<DegreeProgrammeEntity?, DegreeProgrammeFieldError> {
  const DegreeProgrammeFieldInput.unvalidated([DegreeProgrammeEntity? value])
      : super.pure(value);

  const DegreeProgrammeFieldInput.validated([DegreeProgrammeEntity? value])
      : super.dirty(value);

  @override
  DegreeProgrammeFieldError? validator(DegreeProgrammeEntity? value) {
    if (value == null) {
      return DegreeProgrammeFieldError.empty;
    }
    return null;
  }
}

enum DegreeProgrammeFieldError {
  empty,
}

extension DegreeProgrammeFieldErrorExt on DegreeProgrammeFieldError {
  String text() {
    switch (this) {
      case DegreeProgrammeFieldError.empty:
        return "Degree Programme is required";
    }
  }
}
