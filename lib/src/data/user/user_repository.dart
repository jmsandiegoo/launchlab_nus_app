
import 'dart:io';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/create_user_accomplishment_request.dart';
import 'package:launchlab/src/domain/user/models/requests/create_user_experience_request.dart';
import 'package:launchlab/src/domain/user/models/requests/delete_user_accomplishment_request.dart';
import 'package:launchlab/src/domain/user/models/requests/delete_user_experience_request.dart';
import 'package:launchlab/src/domain/user/models/requests/download_avatar_image_request.dart';
import 'package:launchlab/src/domain/user/models/requests/get_profile_info_request.dart';
import 'package:launchlab/src/domain/user/models/requests/onboard_user_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_accomplishment_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_experience_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_preference_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_skills_request.dart';
import 'package:launchlab/src/domain/user/models/responses/create_user_accomplishment_response.dart';
import 'package:launchlab/src/domain/user/models/responses/create_user_experiences_response.dart';
import 'package:launchlab/src/domain/user/models/responses/get_profile_info_response.dart';
import 'package:launchlab/src/domain/user/models/responses/update_user_accomplishment_response.dart';
import 'package:launchlab/src/domain/user/models/responses/update_user_experience_response.dart';
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

  Future<File> downloadAvatarImage(DownloadAvatarImageRequest request) async {
    try {
      return await downloadFile(
          supabase: _supabase,
          bucket: 'user_avatar_bucket',
          fileName: request.fileName);
    } on Exception catch (error) {
      print("download avatar error occured: $error");
      rethrow;
    }
  }

  Future<void> updateUserPreference(UpdateUserPreferenceRequest request) async {
    try {
      await _supabase.client.rpc(
        "handle_user_preference_update",
        params: {"request_data": request.toJson()},
      );
    } on Exception catch (error) {
      print("update user preference error: $error");
      throw const Failure.badRequest();
    }
  }

  Future<void> updateUser(UpdateUserRequest request) async {
    // upload new avatar
    try {
      if (request.userAvatar != null) {
        await uploadFile(
          supabase: _supabase,
          bucket: "user_avatar_bucket",
          file: request.userAvatar!,
          fileIdentifier: "${request.userProfile.id}_avatar",
        );
      }

      if (request.userResume != null) {
        await uploadFile(
          supabase: _supabase,
          bucket: "user_resume_bucket",
          file: request.userResume!,
          fileIdentifier: "${request.userProfile.id}_resume",
        );
      }

      await _supabase.client
          .from("users")
          .update(
            request.userProfile.toJson(),
          )
          .eq('id', request.userProfile.id);
    } on Exception catch (error) {
      print("update user error: $error");
    }
  }

  Future<CreateUserExperienceResponse> createUserExperience(
      CreateUserExperienceRequest request) async {
    try {
      final List<Map<String, dynamic>> res = await _supabase.client
          .from("experiences")
          .insert(request.experience.toJson())
          .select<PostgrestList>("*");

      if (res.isEmpty) {
        throw const Failure.badRequest();
      }

      return CreateUserExperienceResponse(
        experience: ExperienceEntity.fromJson(res[0]),
      );
    } on Exception catch (error) {
      print("create user experience error: $error");
      throw Failure.badRequest();
    }
  }

  Future<UpdateUserExperienceResponse> updateUserExperience(
      UpdateUserExperienceRequest request) async {
    try {
      final List<Map<String, dynamic>> res = await _supabase.client
          .from("experiences")
          .update(
            request.experience.toJson(),
          )
          .eq(
            "id",
            request.experience.id,
          )
          .select<PostgrestList>("*");

      if (res.isEmpty) {
        throw const Failure.badRequest();
      }

      return UpdateUserExperienceResponse(
        experience: ExperienceEntity.fromJson(res[0]),
      );
    } on Exception catch (error) {
      print("update user experience error: $error");
      throw const Failure.badRequest();
    }
  }

  Future<void> deleteUserExperience(DeleteUserExperienceRequest request) async {
    try {
      await _supabase.client.from("experiences").delete().eq(
            'id',
            request.experience.id,
          );
    } on Exception catch (error) {
      print("delete user experience error: $error");
    }
  }

  // update userSkill data
  Future<void> updateUserSkills(UpdateUserSkillsRequest request) async {
    try {
      await _supabase.client.rpc(
        "handle_user_selected_skills_update",
        params: {"request_data": request.toJson()},
      );
    } on Exception catch (error) {
      print("update user skills error: $error");
      throw const Failure.badRequest();
    }
  }

  Future<CreateUserAccomplishmentResponse> createUserAccomplishment(
      CreateUserAccomplishmentRequest request) async {
    try {
      final List<Map<String, dynamic>> res = await _supabase.client
          .from("accomplishments")
          .insert(request.accomplishment.toJson())
          .select<PostgrestList>("*");

      if (res.isEmpty) {
        throw const Failure.badRequest();
      }

      return CreateUserAccomplishmentResponse(
        accomplishment: AccomplishmentEntity.fromJson(res[0]),
      );
    } on Exception catch (error) {
      print("create user accomplishment error: $error");
      throw Failure.badRequest();
    }
  }

  Future<UpdateUserAccomplishmentResponse> updateUserAccomplishment(
      UpdateUserAccomplishmentRequest request) async {
    try {
      final List<Map<String, dynamic>> res = await _supabase.client
          .from("accomplishments")
          .update(
            request.accomplishment.toJson(),
          )
          .eq(
            "id",
            request.accomplishment.id,
          )
          .select<PostgrestList>("*");

      if (res.isEmpty) {
        throw const Failure.badRequest();
      }

      return UpdateUserAccomplishmentResponse(
        accomplishment: AccomplishmentEntity.fromJson(res[0]),
      );
    } on Exception catch (error) {
      print("update user accomplishment error: $error");
      throw const Failure.badRequest();
    }
  }

  Future<void> deleteUserAccomplishment(
      DeleteUserAccomplishmentRequest request) async {
    try {
      await _supabase.client.from("accomplishments").delete().eq(
            'id',
            request.accomplishment.id,
          );
    } on Exception catch (error) {
      print("delete user accomplishment error: $error");
    }
  }
}
