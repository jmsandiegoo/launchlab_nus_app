import 'package:formz/formz.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';

class UserSkillsInterestsFieldInput
    extends FormzInput<List<SkillEntity>, UserSkillsInterestsError> {
  const UserSkillsInterestsFieldInput.unvalidated(
      [List<SkillEntity> value = const []])
      : super.pure(value);
  const UserSkillsInterestsFieldInput.validated(
      [List<SkillEntity> value = const []])
      : super.dirty(value);

  @override
  UserSkillsInterestsError? validator(value) {
    if (value.isEmpty) {
      return UserSkillsInterestsError.empty;
    }
    return null;
  }
}

enum UserSkillsInterestsError {
  empty,
}
