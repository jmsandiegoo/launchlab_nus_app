import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/experience_list_field.dart';

class ProfileExperienceListPageState extends Equatable {
  const ProfileExperienceListPageState({
    this.userExperiences = const ExperienceListFieldInput.unvalidated(),
    required this.userId,
    required this.profileExperienceListPageStatus,
  });

  final ExperienceListFieldInput userExperiences;
  final String userId;
  final ProfileExperienceListPageStatus profileExperienceListPageStatus;

  ProfileExperienceListPageState copyWith({
    ExperienceListFieldInput? userExperiences,
    String? userId,
    ProfileExperienceListPageStatus? profileExperienceListPageStatus,
  }) {
    return ProfileExperienceListPageState(
      userExperiences: userExperiences ?? this.userExperiences,
      userId: userId ?? this.userId,
      profileExperienceListPageStatus: profileExperienceListPageStatus ??
          this.profileExperienceListPageStatus,
    );
  }

  @override
  List<Object?> get props => [
        userExperiences,
        userId,
        profileExperienceListPageStatus,
      ];
}

enum ProfileExperienceListPageStatus {
  initial,
  loading,
  success,
  error,
}

class ProfileExperienceListPageCubit
    extends Cubit<ProfileExperienceListPageState> {
  ProfileExperienceListPageCubit(
      {required List<ExperienceEntity> userExperiences, required String userId})
      : super(ProfileExperienceListPageState(
          userExperiences:
              ExperienceListFieldInput.unvalidated(userExperiences),
          userId: userId,
          profileExperienceListPageStatus:
              ProfileExperienceListPageStatus.initial,
        ));

  void onExperienceListChanged(List<ExperienceEntity> val) {
    final newUserExperiences = ExperienceListFieldInput.validated(val);

    final newState = state.copyWith(
      userExperiences: newUserExperiences,
    );

    emit(newState);
  }

  void handleUpdateStatus(ProfileExperienceListPageStatus status) {
    emit(state.copyWith(profileExperienceListPageStatus: status));
  }
}
