import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/delete_user_avatar_resume_request.dart';
import 'package:launchlab/src/domain/user/models/requests/get_profile_info_request.dart';
import 'package:launchlab/src/domain/user/models/requests/upload_user_resume_request.dart';
import 'package:launchlab/src/domain/user/models/responses/get_profile_info_response.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/domain/user/models/user_resume_entity.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_resume_field.dart';

@immutable
class ProfilePageState extends Equatable {
  const ProfilePageState({
    this.userProfile,
    this.userAvatarUrl,
    this.userAvatar,
    this.userResume,
    this.userDegreeProgramme,
    this.userExperiences = const [],
    this.userAccomplishments = const [],
    this.userPreference,
    required this.profilePageStatus,
    this.userResumeInput = const UserResumeFieldInput.unvalidated(),
  });

  final UserEntity? userProfile;
  final String? userAvatarUrl;
  final UserAvatarEntity? userAvatar;
  final UserResumeEntity? userResume;
  final DegreeProgrammeEntity? userDegreeProgramme;
  final List<ExperienceEntity> userExperiences;
  final List<AccomplishmentEntity> userAccomplishments;
  final PreferenceEntity? userPreference;
  final ProfilePageStatus profilePageStatus;
  final UserResumeFieldInput userResumeInput;

  ProfilePageState copyWith({
    UserEntity? userProfile,
    String? userAvatarUrl,
    UserAvatarEntity? userAvatar,
    UserResumeEntity? userResume,
    DegreeProgrammeEntity? userDegreeProgramme,
    List<ExperienceEntity>? userExperiences,
    List<AccomplishmentEntity>? userAccomplishments,
    PreferenceEntity? userPreference,
    ProfilePageStatus? profilePageStatus,
    UserResumeFieldInput? userResumeInput,
  }) {
    return ProfilePageState(
      userProfile: userProfile ?? this.userProfile,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      userAvatar: userAvatar ?? this.userAvatar,
      userResume: userResume ?? this.userResume,
      userDegreeProgramme: userDegreeProgramme ?? this.userDegreeProgramme,
      userExperiences: userExperiences ?? this.userExperiences,
      userAccomplishments: userAccomplishments ?? this.userAccomplishments,
      userPreference: userPreference ?? this.userPreference,
      profilePageStatus: profilePageStatus ?? this.profilePageStatus,
      userResumeInput: userResumeInput ?? this.userResumeInput,
    );
  }

  @override
  List<Object?> get props => [
        userProfile,
        userAvatarUrl,
        userAvatar,
        userResume,
        userDegreeProgramme,
        userExperiences,
        userAccomplishments,
        userPreference,
        profilePageStatus,
        userResumeInput,
      ];
}

enum ProfilePageStatus {
  initial,
  loading,
  uploadLoading,
  success,
  error,
}

class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit(this._userRepository)
      : super(const ProfilePageState(
          profilePageStatus: ProfilePageStatus.initial,
        ));

  final UserRepository _userRepository;

  Future<void> handleGetProfileInfo(String userId) async {
    // call the user fetch profile
    try {
      final GetProfileInfoResponse res = await _userRepository
          .getProfileInfo(GetProfileInfoRequest(userId: userId));
      emit(state.copyWith(
          userProfile: res.userProfile,
          userAvatar: res.userAvatar,
          userResume: res.userResume,
          userDegreeProgramme: res.userDegreeProgramme,
          userExperiences: res.userExperiences,
          userAccomplishments: res.userAccomplishments,
          userPreference: res.userPreference,
          profilePageStatus: ProfilePageStatus.success,
          userResumeInput:
              UserResumeFieldInput.unvalidated(res.userResume?.file)));
    } on Exception catch (error) {
      debugPrint("error get profile cubit $error");
      emit(state.copyWith(profilePageStatus: ProfilePageStatus.error));
    }
  }

  Future<void> onUserResumeChanged(File? val) async {
    final prevState = state;

    try {
      if (val == null) {
        emit(
            state.copyWith(profilePageStatus: ProfilePageStatus.uploadLoading));

        await _userRepository.deleteUserResume(
            DeleteUserAvatarResumeRequest(userId: state.userProfile!.id!));

        emit(state.copyWith(
          userResumeInput: UserResumeFieldInput.validated(val),
          profilePageStatus: ProfilePageStatus.success,
        ));
      } else {
        emit(state.copyWith(
            userResumeInput: UserResumeFieldInput.validated(val),
            profilePageStatus: ProfilePageStatus.uploadLoading));

        await _userRepository.uploadUserResume(UploadUserResumeRequest(
            userResume:
                UserResumeEntity(userId: state.userProfile!.id!, file: val)));

        emit(state.copyWith(
          profilePageStatus: ProfilePageStatus.success,
        ));
      }
    } on Exception catch (_) {
      emit(state.copyWith(
        userResumeInput:
            UserResumeFieldInput.validated(prevState.userResumeInput.value),
        profilePageStatus: ProfilePageStatus.error,
      ));
    }
  }
}
