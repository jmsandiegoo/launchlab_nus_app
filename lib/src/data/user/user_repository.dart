import 'package:flutter/material.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/check_if_username_exists_request.dart';
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
      List<Map<String, dynamic>> res;
      if (filter != null || filter!.isNotEmpty) {
        res = await _supabase.client
            .from("degree_programmes")
            .select<PostgrestList>('*')
            .filter("name", "ilike", "%$filter%");
      } else {
        res = await _supabase.client
            .from("degree_programmes")
            .select<PostgrestList>('*');
      }

      List<DegreeProgrammeEntity> degreeProgrammeList = [];
      for (int i = 0; i < res.length; i++) {
        degreeProgrammeList.add(DegreeProgrammeEntity.fromJson(res[i]));
      }

      return degreeProgrammeList;
    } on PostgrestException catch (error) {
      debugPrint("get Degree Programme error: $error");
      throw Failure.request(code: error.code);
    } on Exception catch (error) {
      debugPrint("get Degree Programme error: $error");
      throw Failure.unexpected();
    }
  }

  @override
  Future<bool> checkIfUsernameExists(
      CheckIfUsernameExistsRequest request) async {
    try {
      final res = await _supabase.client
          .from("users")
          .select("*")
          .eq("username", request.username);

      if (res.isEmpty) {
        return false;
      } else if (request.currUsername == null) {
        return true;
      } else if (request.currUsername == res[0]['username']) {
        return false;
      } else {
        return true;
      }
    } on PostgrestException catch (error) {
      debugPrint("update user preference postgre error: $error");
      throw Failure.request(code: error.code);
    } on Exception catch (error) {
      debugPrint("update user preference unexpected error occured $error");
      throw Failure.unexpected();
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
    } on Failure catch (_) {
      rethrow;
    } on PostgrestException catch (error) {
      debugPrint("onboard postgre error: $error");
      throw Failure.request(code: error.code);
    } on StorageException catch (error) {
      debugPrint("onboard storage error: $error");
      throw Failure.request(code: error.statusCode);
    } on Exception catch (error) {
      debugPrint("Unexpected error occured $error");
      throw Failure.unexpected();
    }
  }

  Future<void> uploadUserAvatar(UploadUserAvatarRequest request) async {
    try {
      await deleteUserAvatar(
          DeleteUserAvatarResumeRequest(userId: request.userAvatar.userId));

      await uploadFile(
        supabase: _supabase,
        bucket: "user_avatar_bucket",
        uploadFile: request.userAvatar,
      );

      await _supabase.client
          .from("user_avatars")
          .upsert(request.userAvatar.toJson(), onConflict: 'id');
    } on Failure catch (_) {
      rethrow;
    } on PostgrestException catch (error) {
      debugPrint("upload user avatar postgre error: $error");
      throw Failure.request(code: error.code);
    } on StorageException catch (error) {
      debugPrint("Upload user avatar storage error: $error");
      throw Failure.request(code: error.statusCode);
    } on Exception catch (error) {
      debugPrint("Upload user avatar unexpected error: $error");
      throw Failure.unexpected();
    }
  }

  Future<void> uploadUserResume(UploadUserResumeRequest request) async {
    try {
      await deleteUserResume(
          DeleteUserAvatarResumeRequest(userId: request.userResume.userId));

      await uploadFile(
        supabase: _supabase,
        bucket: "user_resume_bucket",
        uploadFile: request.userResume,
      );

      await _supabase.client.from("user_resumes").upsert(
            request.userResume.toJson(),
            onConflict: "user_id",
          );
    } on Failure catch (_) {
      rethrow;
    } on PostgrestException catch (error) {
      debugPrint("upload user resume postgre error: $error");
      throw Failure.request(code: error.code);
    } on StorageException catch (error) {
      debugPrint("Upload user resume storage error: $error");
      throw Failure.request(code: error.statusCode);
    } on Exception catch (error) {
      debugPrint("Upload user resume unexpected error: $error");
      throw Failure.unexpected();
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
    } on PostgrestException catch (error) {
      debugPrint("delete user avatar postgre error: $error");
      throw Failure.request(code: error.code);
    } on StorageException catch (error) {
      debugPrint("delete user avatar storage error: $error");
      throw Failure.request(code: error.statusCode);
    } on Exception catch (error) {
      debugPrint("delete user avatar unexpected error occured $error");
      throw Failure.unexpected();
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
    } on PostgrestException catch (error) {
      debugPrint("delete user resume postgre error: $error");
      throw Failure.request(code: error.code);
    } on StorageException catch (error) {
      debugPrint("delete user resume storage error: $error");
      throw Failure.request(code: error.statusCode);
    } on Exception catch (error) {
      debugPrint("delete user resume unexpected error occured $error");
      throw Failure.unexpected();
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
        debugPrint("No user found while getting profile info.");
        throw Failure.request();
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
        debugPrint("No deg found while getting profile info.");
        throw Failure.request();
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
        debugPrint("No user preference found while getting profile info.");
        throw Failure.request();
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
    } on Failure catch (_) {
      rethrow;
    } on PostgrestException catch (error) {
      debugPrint("fetch user postgre error: $error");
      throw Failure.request(code: error.code);
    } on StorageException catch (error) {
      debugPrint("fetch user storage error: $error");
      throw Failure.request(code: error.statusCode);
    } on Exception catch (error) {
      debugPrint("fetch user unexpected error occured $error");
      throw Failure.unexpected();
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
    } on PostgrestException catch (error) {
      debugPrint("fetch user avatar postgre error: $error");
      throw Failure.request(code: error.code);
    } on StorageException catch (error) {
      debugPrint("fetch user avatar storage error: $error");
      throw Failure.request(code: error.statusCode);
    } on Exception catch (error) {
      debugPrint("fetch user avatar unexpected error occured $error");
      throw Failure.unexpected();
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
          bucket: 'user_resume_bucket',
          fileIdentifier: res[0]['file_identifier'],
          fileName: res[0]['file_name']);

      return UserResumeEntity(
          id: res[0]['id'], userId: res[0]['user_id'], file: file);
    } on PostgrestException catch (error) {
      debugPrint("fetch user resume postgre error: $error");
      throw Failure.request(code: error.code);
    } on StorageException catch (error) {
      debugPrint("fetch user resume storage error: $error");
      throw Failure.request(code: error.statusCode);
    } on Exception catch (error) {
      debugPrint("fetch user resume unexpected error occured $error");
      throw Failure.unexpected();
    }
  }

  @override
  Future<void> updateUserPreference(UpdateUserPreferenceRequest request) async {
    try {
      await _supabase.client.rpc(
        "handle_user_preference_update",
        params: {"request_data": request.toJson()},
      );
    } on PostgrestException catch (error) {
      debugPrint("update user preference postgre error: $error");
      throw Failure.request(code: error.code);
    } on Exception catch (error) {
      debugPrint("update user preference unexpected error occured $error");
      throw Failure.unexpected();
    }
  }

  @override
  Future<void> updateUser(UpdateUserRequest request) async {
    try {
      await _supabase.client
          .from("users")
          .update(request.userProfile.toJson())
          .eq('id', request.userProfile.id);
    } on PostgrestException catch (error) {
      debugPrint("update user postgre error: $error");
      throw Failure.request(
          code: error.code,
          message: error.code != null && error.code == "23505"
              ? "Username is already taken"
              : "Request failed please try again");
    } on Exception catch (error) {
      debugPrint("update user unexpected error occured $error");
      throw Failure.unexpected();
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
        debugPrint("Created user exp was not found");
        throw Failure.unexpected();
      }

      return CreateUserExperienceResponse(
        experience: ExperienceEntity.fromJson(res[0]),
      );
    } on Failure {
      rethrow;
    } on PostgrestException catch (error) {
      debugPrint("create user exp error: $error");
      throw Failure.request(code: error.code);
    } on Exception catch (error) {
      debugPrint("create user exp error occured $error");
      throw Failure.unexpected();
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
        debugPrint("Updated user exp was not found");
        throw Failure.unexpected();
      }

      return UpdateUserExperienceResponse(
        experience: ExperienceEntity.fromJson(res[0]),
      );
    } on Failure {
      rethrow;
    } on PostgrestException catch (error) {
      debugPrint("update user exp error: $error");
      throw Failure.request(code: error.code);
    } on Exception catch (error) {
      debugPrint("update user exp error occured $error");
      throw Failure.unexpected();
    }
  }

  @override
  Future<void> deleteUserExperience(DeleteUserExperienceRequest request) async {
    try {
      await _supabase.client.from("experiences").delete().eq(
            'id',
            request.experience.id,
          );
    } on PostgrestException catch (error) {
      debugPrint("delete user exp error: $error");
      throw Failure.request(code: error.code);
    } on Exception catch (error) {
      debugPrint("delete user exp error occured $error");
      throw Failure.unexpected();
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
    } on PostgrestException catch (error) {
      debugPrint("update user skill postgre error: $error");
      throw Failure.request(code: error.code);
    } on Exception catch (error) {
      debugPrint("update user skill unexpected error occured $error");
      throw Failure.unexpected();
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
        debugPrint("created accomplishment not found.");
        throw Failure.unexpected();
      }

      return CreateUserAccomplishmentResponse(
        accomplishment: AccomplishmentEntity.fromJson(res[0]),
      );
    } on Failure {
      rethrow;
    } on PostgrestException catch (error) {
      debugPrint("create user accomplishemnt error: $error");
      throw Failure.request(code: error.code);
    } on Exception catch (error) {
      debugPrint("create user accomplishment error occured $error");
      throw Failure.unexpected();
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
        debugPrint("updated accomplishment not found.");
        throw Failure.unexpected();
      }

      return UpdateUserAccomplishmentResponse(
        accomplishment: AccomplishmentEntity.fromJson(res[0]),
      );
    } on Failure {
      rethrow;
    } on PostgrestException catch (error) {
      debugPrint("update user accomplishemnt error: $error");
      throw Failure.request(code: error.code);
    } on Exception catch (error) {
      debugPrint("update user accomplishment error occured $error");
      throw Failure.unexpected();
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
    } on PostgrestException catch (error) {
      debugPrint("delete user accomplishment error: $error");
      throw Failure.request(code: error.code);
    } on Exception catch (error) {
      debugPrint("delete user accomplishment error occured $error");
      throw Failure.unexpected();
    }
  }
}
