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
    return null;
  }
}

enum DegreeProgrammeFieldError { none }
