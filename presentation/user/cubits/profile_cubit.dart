import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

@immutable
class ProfileState extends Equatable {
  const ProfileState({
    this.userProfile,
    this.userExperiences = const [],
    this.userAccomplishments = const [],
    required this.profileStateStatus,
  });

  final UserEntity? userProfile;
  final List<ExperienceEntity> userExperiences;
  final List<AccomplishmentEntity> userAccomplishments;
  final ProfileStateStatus profileStateStatus;

  ProfileState copyWith({
    UserEntity? userProfile,
    List<ExperienceEntity>? userExperiences,
    List<AccomplishmentEntity>? userAccomplishments,
    ProfileStateStatus? profileStateStatus,
  }) {
    return ProfileState(
      userProfile: userProfile ?? this.userProfile,
      userExperiences: userExperiences ?? this.userExperiences,
      userAccomplishments: userAccomplishments ?? this.userAccomplishments,
      profileStateStatus: profileStateStatus ?? this.profileStateStatus,
    );
  }

  @override
  List<Object?> get props => [
        userProfile,
        userExperiences,
        userAccomplishments,
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
  ProfileCubit()
      : super(const ProfileState(
          profileStateStatus: ProfileStateStatus.initial,
        ));

  Future<void> handleGetProfileInfo(String? userId) async {
    // call the user fetch profilein
  }

  // update user details;
}
