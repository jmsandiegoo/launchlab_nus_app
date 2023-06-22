import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/get_profile_info_request.dart';
import 'package:launchlab/src/domain/user/models/requests/onboard_user_request.dart';
import 'package:launchlab/src/domain/user/models/responses/get_profile_info_response.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
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
          .from("degree_programmes")
          .select<PostgrestList>('*')
          .filter("name", "ilike", "%$filter%");

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

  @override
  Future<void> onboardUser({required OnboardUserRequest request}) async {
    // upload the file and avatar
    try {
      String? userAvatarIdentifier;
      String? userResumeIdentifier;

      if (request.userAvatar != null) {
        userAvatarIdentifier = await uploadFile(
          supabase: _supabase,
          bucket: "user_avatar_bucket",
          file: request.userAvatar!,
          fileIdentifier: "${request.user.id}_avatar",
        );
      }

      if (request.userResume != null) {
        userResumeIdentifier = await uploadFile(
          supabase: _supabase,
          bucket: "user_resume_bucket",
          file: request.userResume!,
          fileIdentifier: "${request.user.id}_resume",
        );
      }

      // update the request data with the file and resume respectively
      final newOnboardUserRequest = request.copyWith(
          user: request.user.copyWith(
        avatar: userAvatarIdentifier,
        resume: userResumeIdentifier,
      ));

      await _supabase.client.rpc(
        "handle_onboard_user",
        params: {"request_data": newOnboardUserRequest.toJson()},
      );

      // call the rpc function to insert into db
    } on StorageException catch (error) {
      print("onboard storage error: $error");
    } on Exception catch (error) {
      print("Unexpected error occured $error");
    }
  }

  Future<GetProfileInfoResponse> getProfileInfo(
      GetProfileInfoRequest request) async {
    try {
      // fetch the user profile
      final userRes = await _supabase.client
          .from("users")
          .select<PostgrestList>("*")
          .eq("id", request.userId);

      if (userRes.isEmpty) {
        print("profile not found");
        throw Failure.badRequest();
      }

      final UserEntity user = UserEntity.fromJson(userRes[0]);

      // fetch the profile picture
      String? avatarUrl;

      if (user.avatar != null) {
        avatarUrl = await _supabase.client.storage
            .from("user_avatar_bucket")
            .createSignedUrl(user.avatar!, 60);
      }

      // fetch the profile degree
      final degRes = await _supabase.client
          .from("degree_programmes")
          .select<PostgrestList>("*")
          .eq(
            'id',
            user.degreeProgrammeId,
          );

      if (degRes.isEmpty) {
        throw Failure.badRequest();
      }

      DegreeProgrammeEntity deg = DegreeProgrammeEntity.fromJson(degRes[0]);

      // fetch the experiences
      final expRes = await _supabase.client
          .from("experiences")
          .select<PostgrestList>("*")
          .eq("user_id", request.userId);

      List<ExperienceEntity> experienceList = [];

      for (int i = 0; i < expRes.length; i++) {
        experienceList.add(ExperienceEntity.fromJson(expRes[i]));
      }

      // fetch the accomplishments
      final accRes = await _supabase.client
          .from("accomplishments")
          .select<PostgrestList>("*")
          .eq("user_id", request.userId);

      List<AccomplishmentEntity> accomplishmentList = [];

      for (int i = 0; i < accRes.length; i++) {
        accomplishmentList.add(AccomplishmentEntity.fromJson(accRes[i]));
      }

      // fetch prefernce with interests & skills and category
      final prefRes = await _supabase.client
          .from("preferences")
          .select<PostgrestList>(
              "*, skills_interests:skills_preferences(selected_skills(*)), categories:categories_preferences(categories(*))")
          .eq(
            'user_id',
            request.userId,
          );

      if (prefRes.isEmpty) {
        throw Failure.badRequest();
      }

      final PreferenceEntity pref = PreferenceEntity.fromJson(prefRes[0]);

      return GetProfileInfoResponse(
          userProfile: user,
          userAvatarUrl: avatarUrl,
          userDegreeProgramme: deg,
          userExperiences: experienceList,
          userAccomplishments: accomplishmentList,
          userPreference: pref);
    } on Exception catch (error) {
      print("get Profile error occured $error");
      rethrow;
    }
  }
}
