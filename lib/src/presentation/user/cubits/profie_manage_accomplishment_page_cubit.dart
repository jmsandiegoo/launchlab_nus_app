import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/accomplishments_list_field.dart';

class ProfileManageAccomplishmentPageState extends Equatable {
  const ProfileManageAccomplishmentPageState({
    this.userAccomplishments = const AccomplishmentListFieldInput.unvalidated(),
    required this.profileManageAccomplishmentPageStatus,
  });

  final AccomplishmentListFieldInput userAccomplishments;
  final ProfileManageAccomplishmentPageStatus
      profileManageAccomplishmentPageStatus;

  ProfileManageAccomplishmentPageState copyWith({
    AccomplishmentListFieldInput? userAccomplishments,
    ProfileManageAccomplishmentPageStatus?
        profileManageAccomplishmentPageStatus,
  }) {
    return ProfileManageAccomplishmentPageState(
      userAccomplishments: userAccomplishments ?? this.userAccomplishments,
      profileManageAccomplishmentPageStatus:
          profileManageAccomplishmentPageStatus ??
              this.profileManageAccomplishmentPageStatus,
    );
  }

  @override
  List<Object?> get props => [
        userAccomplishments,
        profileManageAccomplishmentPageStatus,
      ];
}

enum ProfileManageAccomplishmentPageStatus {
  initial,
  loading,
  success,
  error,
}

class ProfileManageAccomplishmentPageCubit
    extends Cubit<ProfileManageAccomplishmentPageState> {
  ProfileManageAccomplishmentPageCubit(
      {required List<AccomplishmentEntity> userAccomplishments})
      : super(ProfileManageAccomplishmentPageState(
          userAccomplishments:
              AccomplishmentListFieldInput.unvalidated(userAccomplishments),
          profileManageAccomplishmentPageStatus:
              ProfileManageAccomplishmentPageStatus.initial,
        ));

  void onAccomplishmentListChanged(List<AccomplishmentEntity> val) {
    final newUserAccomplishments = AccomplishmentListFieldInput.validated(val);

    final newState = state.copyWith(
      userAccomplishments: newUserAccomplishments,
      profileManageAccomplishmentPageStatus:
          ProfileManageAccomplishmentPageStatus.success,
    );

    emit(newState);
  }

  void handleUpdateStatus(ProfileManageAccomplishmentPageStatus status) {
    emit(state.copyWith(profileManageAccomplishmentPageStatus: status));
  }
}
