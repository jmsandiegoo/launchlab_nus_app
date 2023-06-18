import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';

abstract class UserRepositoryImpl {
  Future<List<DegreeProgrammeEntity>> getDegreeProgrammes(String? filter);
}
