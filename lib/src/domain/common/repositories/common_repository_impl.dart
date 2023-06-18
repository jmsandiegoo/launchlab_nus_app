import 'package:dartz/dartz.dart';
import 'package:launchlab/src/domain/common/models/category_entity.dart';
import 'package:launchlab/src/utils/failure.dart';

abstract class CommonRepositoryImpl {
  /// Get categories
  /// throws Failure
  Future<List<CategoryEntity>> getCategories();
}
