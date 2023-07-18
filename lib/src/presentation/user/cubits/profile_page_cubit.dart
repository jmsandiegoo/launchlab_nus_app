import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/requests/delete_user_avatar_resume_request.dart';
import 'package:launchlab/src/domain/user/models/requests/get_profile_info_request.dart';
import 'package:launchlab/src/domain/user/models/requests/upload_user_resume_request.dart';
import 'package:launchlab/src/domain/user/models/responses/get_profile_info_response.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/domain/user/models/user_resume_entity.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_resume_field.dart';
import 'package:launchlab/src/utils/failure.dart';

@immutable
class ProfilePageState extends Equatable {
  const ProfilePageState({
    this.userProfile,
    required this.profilePageStatus,
    this.userResumeInput = const UserResumeFieldInput.unvalidated(),
    this.error,
  });

  final UserEntity? userProfile;
  final ProfilePageStatus profilePageStatus;
  final UserResumeFieldInput userResumeInput;
  final Failure? error;

  ProfilePageState copyWith({
    UserEntity? userProfile,
    ProfilePageStatus? profilePageStatus,
    UserResumeFieldInput? userResumeInput,
    Failure? error,
  }) {
    return ProfilePageState(
      userProfile: userProfile ?? this.userProfile,
      profilePageStatus: profilePageStatus ?? this.profilePageStatus,
      userResumeInput: userResumeInput ?? this.userResumeInput,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        userProfile,
        profilePageStatus,
        userResumeInput,
        error,
      ];
}

enum ProfilePageStatus {
  initial,
  loading,
  uploadLoading,
  success,
  error,
  uploadError,
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
      emit(state.copyWith(profilePageStatus: ProfilePageStatus.loading));
      final GetProfileInfoResponse res = await _userRepository
          .getProfileInfo(GetProfileInfoRequest(userId: userId));
      emit(state.copyWith(
          userProfile: res.userProfile,
          profilePageStatus: ProfilePageStatus.success,
          userResumeInput: UserResumeFieldInput.unvalidated(
              res.userProfile.userResume?.file)));
    } on Failure catch (error) {
      emit(state.copyWith(
          profilePageStatus: ProfilePageStatus.error, error: error));
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
    } on Failure catch (error) {
      emit(state.copyWith(
        userResumeInput:
            UserResumeFieldInput.validated(prevState.userResumeInput.value),
        profilePageStatus: ProfilePageStatus.uploadError,
        error: error,
      ));
    }
  }
}
