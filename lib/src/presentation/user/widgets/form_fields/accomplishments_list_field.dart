import 'package:formz/formz.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';

class AccomplishmentListFieldInput extends FormzInput<
    List<AccomplishmentEntity>, AccomplishmentListFieldError> {
  const AccomplishmentListFieldInput.unvalidated(
      [List<AccomplishmentEntity> value = const []])
      : super.pure(value);
  const AccomplishmentListFieldInput.validated(
      [List<AccomplishmentEntity> value = const []])
      : super.dirty(value);

  @override
  AccomplishmentListFieldError? validator(List<AccomplishmentEntity> value) {
    // Size check todo in the future
    return null;
  }
}

enum AccomplishmentListFieldError {
  none,
}
