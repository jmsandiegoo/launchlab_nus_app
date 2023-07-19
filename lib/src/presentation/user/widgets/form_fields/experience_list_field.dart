import 'package:formz/formz.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';

class ExperienceListFieldInput
    extends FormzInput<List<ExperienceEntity>, ExperienceListFieldError> {
  const ExperienceListFieldInput.unvalidated(
      [List<ExperienceEntity> value = const []])
      : super.pure(value);
  const ExperienceListFieldInput.validated(
      [List<ExperienceEntity> value = const []])
      : super.dirty(value);

  @override
  ExperienceListFieldError? validator(List<ExperienceEntity> value) {
    // Size check todo in the future
    return null;
  }
}

enum ExperienceListFieldError {
  none,
}
