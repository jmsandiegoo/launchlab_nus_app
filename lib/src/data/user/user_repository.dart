import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/onboard_user_request.dart';
import 'package:launchlab/src/domain/user/repositories/user_repository_impl.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:launchlab/src/utils/helper.dart';
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

  // @override
  Future<void> onboardUser({required OnboardUserRequest request}) async {
    // upload the file and avatar
    try {
      String? userAvatarIdentifier;
      String? userResumeIdentifier;

      if (request.userAvatar != null) {
        userAvatarIdentifier = "${request.user.id}_avatar";
        await uploadFile(
          supabase: _supabase,
          bucket: 'user_avatar_bucket',
          file: request.userAvatar!,
          fileIdentifier: userAvatarIdentifier,
        );
      }

      if (request.userResume != null) {
        userResumeIdentifier = "${request.user.id}_resume";
        await uploadFile(
          supabase: _supabase,
          bucket: 'user_resume_bucker',
          file: request.userResume!,
          fileIdentifier: userResumeIdentifier,
        );
      }

      // update the request data with the file and resume respectively
      final newOnboardUserRequest = request.copyWith(
          user: request.user.copyWith(
        avatar: userAvatarIdentifier,
        resume: userResumeIdentifier,
      ));

      final res = await _supabase.client.rpc(
        'handle_onboard_user',
        params: {'request_data': newOnboardUserRequest.toJson()},
      );

      // await _supabase.client.rpc(
      //   'plv8_test_function',
      // );

      print(res);

      // call the rpc function to insert into db
    } on StorageException catch (error) {
      print("onboard storage error: $error");
    } on Exception catch (error) {
      print("Unexpected error occured $error");
    }
  }
}
