import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/repositories/user_repository_impl.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository implements UserRepositoryImpl {
  final Supabase _supabase;
  UserRepository(this._supabase);

  @override
  Future<List<DegreeProgrammeEntity>> getDegreeProgrammes(
      String? filter) async {
    try {
      final res = await _supabase.client
          .from('degree_programmes')
          .select<PostgrestList>('*')
          .filter('name', 'ilike', '%$filter%');

      List<DegreeProgrammeEntity> degreeProgrammeList = [];
      for (int i = 0; i < res.length; i++) {
        degreeProgrammeList.add(DegreeProgrammeEntity.fromJson(res[i]));
      }

      return degreeProgrammeList;
    } on AuthException catch (error) {
      print("get Degree Programme error: ${error}");
      throw const Failure.unauthorized();
    } on Exception catch (error) {
      print("get Degree Programme error: ${error}");
      throw const Failure.badRequest();
    }
  }
}
