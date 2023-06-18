import 'package:launchlab/src/domain/common/models/category_entity.dart';
import 'package:launchlab/src/domain/common/repositories/common_repository_impl.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommonRepository implements CommonRepositoryImpl {
  final Supabase _supabase;
  CommonRepository(this._supabase);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final res =
          await _supabase.client.from('categories').select<PostgrestList>('*');
      print("res ${res}");
      List<CategoryEntity> categoryList = [];

      for (int i = 0; i < res.length; i++) {
        categoryList.add(CategoryEntity.fromJson(res[i]));
      }

      return categoryList;
    } on Exception catch (error) {
      print("get Categories error: ${error}");
      throw const Failure.badRequest();
    }
  }
}
