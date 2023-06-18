import 'package:formz/formz.dart';

class UserSkillsInterestsFieldInput
    extends FormzInput<List<String>, UserSkillsInterestsError> {
  const UserSkillsInterestsFieldInput.unvalidated(
      [List<String> value = const []])
      : super.pure(value);
  const UserSkillsInterestsFieldInput.validated([List<String> value = const []])
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
