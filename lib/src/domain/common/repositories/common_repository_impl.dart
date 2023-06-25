import 'package:launchlab/src/domain/common/models/category_entity.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';

abstract class CommonRepositoryImpl {
  Future<List<CategoryEntity>> getCategories();

  Future<List<SkillEntity>> getSkillsInterestsFromEmsi(String? filter);

  Future<String> getNewEmsiToken();
}
