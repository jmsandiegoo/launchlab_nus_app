import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/get_profile_info_request.dart';
import 'package:launchlab/src/domain/user/models/responses/get_profile_info_response.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

@immutable
class ProfileState extends Equatable {
  const ProfileState({
    this.userProfile,
    this.userAvatarUrl,
    this.userDegreeProgramme,
    this.userExperiences = const [],
    this.userAccomplishments = const [],
    this.userPreference,
    required this.profileStateStatus,
  });

  final UserEntity? userProfile;
  final String? userAvatarUrl;
  final DegreeProgrammeEntity? userDegreeProgramme;
  final List<ExperienceEntity> userExperiences;
  final List<AccomplishmentEntity> userAccomplishments;
  final PreferenceEntity? userPreference;
  final ProfileStateStatus profileStateStatus;

  ProfileState copyWith({
    UserEntity? userProfile,
    String? userAvatarUrl,
    DegreeProgrammeEntity? userDegreeProgramme,
    List<ExperienceEntity>? userExperiences,
    List<AccomplishmentEntity>? userAccomplishments,
    PreferenceEntity? userPreference,
    ProfileStateStatus? profileStateStatus,
  }) {
    return ProfileState(
      userProfile: userProfile ?? this.userProfile,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      userDegreeProgramme: userDegreeProgramme ?? this.userDegreeProgramme,
      userExperiences: userExperiences ?? this.userExperiences,
      userAccomplishments: userAccomplishments ?? this.userAccomplishments,
      userPreference: userPreference ?? this.userPreference,
      profileStateStatus: profileStateStatus ?? this.profileStateStatus,
    );
  }

  @override
  List<Object?> get props => [
        userProfile,
        userAvatarUrl,
        userDegreeProgramme,
        userExperiences,
        userAccomplishments,
        userPreference,
        profileStateStatus,
      ];
}

enum ProfileStateStatus {
  initial,
  loading,
  success,
  error,
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._userRepository)
      : super(const ProfileState(
          profileStateStatus: ProfileStateStatus.initial,
        ));

  final UserRepository _userRepository;

  Future<void> handleGetProfileInfo(String userId) async {
    // call the user fetch profilein
    try {
      emit(state.copyWith(profileStateStatus: ProfileStateStatus.loading));
      final GetProfileInfoResponse res = await _userRepository
          .getProfileInfo(GetProfileInfoRequest(userId: userId));
      emit(state.copyWith(
        userProfile: res.userProfile,
        userAvatarUrl: res.userAvatarUrl,
        userDegreeProgramme: res.userDegreeProgramme,
        userExperiences: res.userExperiences,
        userAccomplishments: res.userAccomplishments,
        userPreference: res.userPreference,
        profileStateStatus: ProfileStateStatus.success,
      ));
    } on Exception catch (error) {
      print("error get profile cubit $error");
      emit(state.copyWith(profileStateStatus: ProfileStateStatus.error));
    }
  }
}
