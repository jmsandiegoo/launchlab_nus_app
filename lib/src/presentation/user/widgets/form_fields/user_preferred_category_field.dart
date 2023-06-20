import 'package:formz/formz.dart';
import 'package:launchlab/src/domain/common/models/category_entity.dart';

class UserPreferredCategoryFieldInput
    extends FormzInput<List<CategoryEntity>, UserPreferredCategoryError> {
  const UserPreferredCategoryFieldInput.unvalidated(
      [List<CategoryEntity> value = const []])
      : super.pure(value);
  const UserPreferredCategoryFieldInput.validated(
      [List<CategoryEntity> value = const []])
      : super.dirty(value);

  @override
  UserPreferredCategoryError? validator(value) {
    if (value.isEmpty) {
      return UserPreferredCategoryError.empty;
    }
    return null;
  }
}

enum UserPreferredCategoryError {
  empty,
}
