import 'package:flutter/material.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/create_user_accomplishment_request.dart';
import 'package:launchlab/src/domain/user/models/requests/create_user_experience_request.dart';
import 'package:launchlab/src/domain/user/models/requests/delete_user_accomplishment_request.dart';
import 'package:launchlab/src/domain/user/models/requests/delete_user_avatar_resume_request.dart';
import 'package:launchlab/src/domain/user/models/requests/delete_user_experience_request.dart';
import 'package:launchlab/src/domain/user/models/requests/download_avatar_image_request.dart';
import 'package:launchlab/src/domain/user/models/requests/download_user_resume_request.dart';
import 'package:launchlab/src/domain/user/models/requests/get_profile_info_request.dart';
import 'package:launchlab/src/domain/user/models/requests/onboard_user_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_accomplishment_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_experience_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_preference_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_skills_request.dart';
import 'package:launchlab/src/domain/user/models/requests/upload_user_avatar_request.dart';
import 'package:launchlab/src/domain/user/models/requests/upload_user_resume_request.dart';
import 'package:launchlab/src/domain/user/models/responses/create_user_accomplishment_response.dart';
import 'package:launchlab/src/domain/user/models/responses/create_user_experiences_response.dart';
import 'package:launchlab/src/domain/user/models/responses/get_profile_info_response.dart';
import 'package:launchlab/src/domain/user/models/responses/update_user_accomplishment_response.dart';
import 'package:launchlab/src/domain/user/models/responses/update_user_experience_response.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/domain/user/models/user_resume_entity.dart';
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
      debugPrint("get Degree Programme error: $error");
      throw const Failure.unauthorized();
    } on Exception catch (error) {
      debugPrint("get Degree Programme error: $error");
      throw const Failure.badRequest();
    }
  }

  @override
  Future<void> onboardUser({required OnboardUserRequest request}) async {
    // upload the file and avatar
    try {
      if (request.userAvatar != null) {
        uploadUserAvatar(
            UploadUserAvatarRequest(userAvatar: request.userAvatar!));
      }

      if (request.userResume != null) {
        uploadUserResume(
            UploadUserResumeRequest(userResume: request.userResume!));
      }

      await _supabase.client.rpc(
        "handle_onboard_user",
        params: {"request_data": request.toJson()},
      );

      // call the rpc function to insert into db
    } on StorageException catch (error) {
      debugPrint("onboard storage error: $error");
    } on Exception catch (error) {
      debugPrint("Unexpected error occured $error");
    }
  }

  Future<void> uploadUserAvatar(UploadUserAvatarRequest request) async {
    try {
      await uploadFile(
        supabase: _supabase,
        bucket: "user_avatar_bucket",
        uploadFile: request.userAvatar,
      );

      await _supabase.client
          .from("user_avatars")
          .upsert(request.userAvatar.toJson(), onConflict: 'id');
    } on Exception catch (error) {
      debugPrint("Upload user avatar error: $error");
    }
  }

  Future<void> uploadUserResume(UploadUserResumeRequest request) async {
    try {
      await uploadFile(
        supabase: _supabase,
        bucket: "user_avatar_bucket",
        uploadFile: request.userResume,
      );

      await _supabase.client
          .from("user_resumes")
          .upsert(request.userResume.toJson(), onConflict: "user_id");
    } on Exception catch (error) {
      debugPrint("Upload user resume error: $error");
    }
  }

  Future<void> deleteUserAvatar(DeleteUserAvatarResumeRequest request) async {
    try {
      final res = await _supabase.client
          .from("user_avatars")
          .select<PostgrestList>("*")
          .eq(
            "user_id",
            request.userId,
          );

      if (res.isEmpty) {
        return;
      }

      await deleteFile(
        supabase: _supabase,
        bucket: "user_avatar_bucket",
        fileIdentifier: res[0]['file_identifier'],
      );

      await _supabase.client
          .from("user_avatars")
          .delete()
          .eq("user_id", request.userId);
    } on Exception catch (error) {
      debugPrint("Delete user avatar error: $error");
    }
  }

  Future<void> deleteUserResume(DeleteUserAvatarResumeRequest request) async {
    try {
      final res = await _supabase.client
          .from("user_resumes")
          .select<PostgrestList>("*")
          .eq(
            "user_id",
            request.userId,
          );

      if (res.isEmpty) {
        return;
      }

      await deleteFile(
        supabase: _supabase,
        bucket: "user_resumes_bucket",
        fileIdentifier: res[0]['file_identifier'],
      );

      await _supabase.client
          .from("user_resumes")
          .delete()
          .eq("user_id", request.userId);
    } on Exception catch (error) {
      debugPrint("Delete user resume error: $error");
    }
  }

  @override
  Future<GetProfileInfoResponse> getProfileInfo(
      GetProfileInfoRequest request) async {
    try {
      // fetch the user profile
      final userRes = await _supabase.client
          .from("users")
          .select<PostgrestList>("*")
          .eq("id", request.userId);

      if (userRes.isEmpty) {
        throw const Failure.badRequest();
      }

      final UserEntity user = UserEntity.fromJson(userRes[0]);

      // fetch the profile picture
      UserAvatarEntity? userAvatar =
          await fetchUserAvatar(DownloadAvatarImageRequest(
        userId: user.id!,
        isSignedUrlEnabled: true,
      ));

      // fetch the user resume
      UserResumeEntity? userResume =
          await fetchUserResume(DownloadUserResumeRequest(userId: user.id!));

      // fetch the profile degree
      final degRes = await _supabase.client
          .from("degree_programmes")
          .select<PostgrestList>("*")
          .eq(
            'id',
            user.degreeProgrammeId,
          );

      if (degRes.isEmpty) {
        throw const Failure.badRequest();
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
        throw const Failure.badRequest();
      }

      final PreferenceEntity pref = PreferenceEntity.fromJson(prefRes[0]);

      return GetProfileInfoResponse(
          userProfile: user,
          userAvatar: userAvatar,
          userResume: userResume,
          userDegreeProgramme: deg,
          userExperiences: experienceList,
          userAccomplishments: accomplishmentList,
          userPreference: pref);
    } on Exception catch (error) {
      debugPrint("get Profile error occured $error");
      rethrow;
    }
  }

  @override
  Future<UserAvatarEntity?> fetchUserAvatar(
      DownloadAvatarImageRequest request) async {
    try {
      final res = await _supabase.client
          .from("user_avatars")
          .select<PostgrestList>("*")
          .eq("user_id", request.userId);
      debugPrint(res.toString());

      if (res.isEmpty) {
        return null;
      }

      final file = await downloadFile(
          supabase: _supabase,
          bucket: 'user_avatar_bucket',
          fileIdentifier: res[0]['file_identifier'],
          fileName: res[0]['file_name']);

      String? signedUrl;

      if (request.isSignedUrlEnabled) {
        signedUrl = await _supabase.client.storage
            .from("user_avatar_bucket")
            .createSignedUrl(res[0]['file_identifier'], 60);
      }

      return UserAvatarEntity(
          id: res[0]['id'],
          userId: res[0]['user_id'],
          file: file,
          signedUrl: signedUrl);
    } on Exception catch (error) {
      debugPrint("download avatar error occured: $error");
      rethrow;
    }
  }

  @override
  Future<UserResumeEntity?> fetchUserResume(
      DownloadUserResumeRequest request) async {
    try {
      final res = await _supabase.client
          .from("user_resumes")
          .select<PostgrestList>("*")
          .eq("user_id", request.userId);
      debugPrint(res.toString());

      if (res.isEmpty) {
        return null;
      }

      final file = await downloadFile(
          supabase: _supabase,
          bucket: 'user_avatar_bucket',
          fileIdentifier: res[0]['file_identifier'],
          fileName: res[0]['file_name']);

      return UserResumeEntity(
          id: res[0]['id'], userId: res[0]['user_id'], file: file);
    } on Exception catch (error) {
      debugPrint("download resume error occured: $error");
      rethrow;
    }
  }

  @override
  Future<void> updateUserPreference(UpdateUserPreferenceRequest request) async {
    try {
      await _supabase.client.rpc(
        "handle_user_preference_update",
        params: {"request_data": request.toJson()},
      );
    } on Exception catch (error) {
      debugPrint("update user preference error: $error");
      throw const Failure.badRequest();
    }
  }

  @override
  Future<void> updateUser(UpdateUserRequest request) async {
    try {
      await _supabase.client
          .from("users")
          .update(request.userProfile.toJson())
          .eq('id', request.userProfile.id);
    } on Exception catch (error) {
      debugPrint("update user error: $error");
    }
  }

  @override
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
      debugPrint("create user experience error: $error");
      throw const Failure.badRequest();
    }
  }

  @override
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
      debugPrint("update user experience error: $error");
      throw const Failure.badRequest();
    }
  }

  @override
  Future<void> deleteUserExperience(DeleteUserExperienceRequest request) async {
    try {
      await _supabase.client.from("experiences").delete().eq(
            'id',
            request.experience.id,
          );
    } on Exception catch (error) {
      debugPrint("delete user experience error: $error");
    }
  }

  // update userSkill data
  @override
  Future<void> updateUserSkills(UpdateUserSkillsRequest request) async {
    try {
      await _supabase.client.rpc(
        "handle_user_selected_skills_update",
        params: {"request_data": request.toJson()},
      );
    } on Exception catch (error) {
      debugPrint("update user skills error: $error");
      throw const Failure.badRequest();
    }
  }

  @override
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
      debugPrint("create user accomplishment error: $error");
      throw const Failure.badRequest();
    }
  }

  @override
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
      debugPrint("update user accomplishment error: $error");
      throw const Failure.badRequest();
    }
  }

  @override
  Future<void> deleteUserAccomplishment(
      DeleteUserAccomplishmentRequest request) async {
    try {
      await _supabase.client.from("accomplishments").delete().eq(
            'id',
            request.accomplishment.id,
          );
    } on Exception catch (error) {
      debugPrint("delete user accomplishment error: $error");
    }
  }
}
