import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/create_user_accomplishment_request.dart';
import 'package:launchlab/src/domain/user/models/requests/create_user_experience_request.dart';
import 'package:launchlab/src/domain/user/models/requests/delete_user_accomplishment_request.dart';
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
import 'package:launchlab/src/domain/user/models/responses/create_user_accomplishment_response.dart';
import 'package:launchlab/src/domain/user/models/responses/create_user_experiences_response.dart';
import 'package:launchlab/src/domain/user/models/responses/get_profile_info_response.dart';
import 'package:launchlab/src/domain/user/models/responses/update_user_accomplishment_response.dart';
import 'package:launchlab/src/domain/user/models/responses/update_user_experience_response.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/domain/user/models/user_resume_entity.dart';

abstract class UserRepositoryImpl {
  Future<List<DegreeProgrammeEntity>> getDegreeProgrammes(String? filter);

  Future<void> onboardUser({required OnboardUserRequest request});

  Future<GetProfileInfoResponse> getProfileInfo(GetProfileInfoRequest request);

  Future<UserAvatarEntity?> fetchUserAvatar(DownloadAvatarImageRequest request);

  Future<UserResumeEntity?> fetchUserResume(DownloadUserResumeRequest request);

  Future<void> updateUserPreference(UpdateUserPreferenceRequest request);

  Future<void> updateUser(UpdateUserRequest request);

  Future<CreateUserExperienceResponse> createUserExperience(
      CreateUserExperienceRequest request);

  Future<UpdateUserExperienceResponse> updateUserExperience(
      UpdateUserExperienceRequest request);

  Future<void> deleteUserExperience(DeleteUserExperienceRequest request);

  Future<void> updateUserSkills(UpdateUserSkillsRequest request);

  Future<CreateUserAccomplishmentResponse> createUserAccomplishment(
      CreateUserAccomplishmentRequest request);

  Future<UpdateUserAccomplishmentResponse> updateUserAccomplishment(
      UpdateUserAccomplishmentRequest request);

  Future<void> deleteUserAccomplishment(
      DeleteUserAccomplishmentRequest request);
}
