import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/onboard_user_request.dart';

abstract class UserRepositoryImpl {
  Future<List<DegreeProgrammeEntity>> getDegreeProgrammes(String? filter);

  Future<void> onboardUser({required OnboardUserRequest request});
}
