import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/experience_list_field.dart';

class ProfileManageExperiencePageState extends Equatable {
  const ProfileManageExperiencePageState({
    this.userExperiences = const ExperienceListFieldInput.unvalidated(),
    required this.profileExperienceListPageStatus,
  });

  final ExperienceListFieldInput userExperiences;
  final ProfileExperienceListPageStatus profileExperienceListPageStatus;

  ProfileManageExperiencePageState copyWith({
    ExperienceListFieldInput? userExperiences,
    ProfileExperienceListPageStatus? profileExperienceListPageStatus,
  }) {
    return ProfileManageExperiencePageState(
      userExperiences: userExperiences ?? this.userExperiences,
      profileExperienceListPageStatus: profileExperienceListPageStatus ??
          this.profileExperienceListPageStatus,
    );
  }

  @override
  List<Object?> get props => [
        userExperiences,
        profileExperienceListPageStatus,
      ];
}

enum ProfileExperienceListPageStatus {
  initial,
  loading,
  success,
  error,
}

class ProfileManageExperiencePageCubit
    extends Cubit<ProfileManageExperiencePageState> {
  ProfileManageExperiencePageCubit(
      {required List<ExperienceEntity> userExperiences})
      : super(ProfileManageExperiencePageState(
          userExperiences:
              ExperienceListFieldInput.unvalidated(userExperiences),
          profileExperienceListPageStatus:
              ProfileExperienceListPageStatus.initial,
        ));

  void onExperienceListChanged(List<ExperienceEntity> val) {
    final newUserExperiences = ExperienceListFieldInput.validated(val);

    final newState = state.copyWith(
      userExperiences: newUserExperiences,
      profileExperienceListPageStatus: ProfileExperienceListPageStatus.success,
    );

    emit(newState);
  }

  void handleUpdateStatus(ProfileExperienceListPageStatus status) {
    emit(state.copyWith(profileExperienceListPageStatus: status));
  }
}
