import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/download_avatar_image_request.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class ProfileEditIntroPageState extends Equatable {
  const ProfileEditIntroPageState(
      {required this.userProfile,
      required this.userDegreeProgramme,
      this.avatarFile,
      required this.profileEditIntroPageStatus});

  final UserEntity userProfile;
  final DegreeProgrammeEntity userDegreeProgramme;
  final File? avatarFile;
  final ProfileEditintroPageStatus profileEditIntroPageStatus;

  ProfileEditIntroPageState copyWith({
    UserEntity? userProfile,
    DegreeProgrammeEntity? userDegreeProgramme,
    File? avatarFile,
    ProfileEditintroPageStatus? profileEditIntroPageStatus,
  }) {
    return ProfileEditIntroPageState(
      userProfile: userProfile ?? this.userProfile,
      userDegreeProgramme: userDegreeProgramme ?? this.userDegreeProgramme,
      avatarFile: avatarFile ?? this.avatarFile,
      profileEditIntroPageStatus:
          profileEditIntroPageStatus ?? this.profileEditIntroPageStatus,
    );
  }

  @override
  List<Object?> get props => [
        userProfile,
        userDegreeProgramme,
        avatarFile,
        profileEditIntroPageStatus,
      ];
}

enum ProfileEditintroPageStatus {
  initial,
  loading,
  success,
  error,
  formLoading,
}

class ProfileEditIntroPageCubit extends Cubit<ProfileEditIntroPageState> {
  ProfileEditIntroPageCubit(
      {required this.userRepository,
      required UserEntity userProfile,
      required DegreeProgrammeEntity userDegreeProgramme})
      : super(ProfileEditIntroPageState(
          userProfile: userProfile,
          userDegreeProgramme: userDegreeProgramme,
          profileEditIntroPageStatus: ProfileEditintroPageStatus.initial,
        ));

  final UserRepository userRepository;

  Future<void> handleInitialiseForm() async {
    try {
      emit(state.copyWith(
        profileEditIntroPageStatus: ProfileEditintroPageStatus.loading,
      ));

      File? avatarImg;

      if (state.userProfile.avatar != null) {
        avatarImg = await userRepository.downloadAvatarImage(
            DownloadAvatarImageRequest(fileName: state.userProfile.avatar!));
      }

      emit(state.copyWith(
          avatarFile: avatarImg,
          profileEditIntroPageStatus: ProfileEditintroPageStatus.success));
    } on Exception catch (error) {
      emit(state.copyWith(
          profileEditIntroPageStatus: ProfileEditintroPageStatus.error));
    }
  }

  void handleUpdateStatus(ProfileEditintroPageStatus status) {
    emit(state.copyWith(profileEditIntroPageStatus: status));
  }
}
