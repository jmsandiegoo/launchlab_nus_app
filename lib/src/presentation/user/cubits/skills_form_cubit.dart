import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_skills_request.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_skills_interests_field.dart';

class SkillsFormState extends Equatable {
  const SkillsFormState({
    this.userSkillsInterestsInput =
        const UserSkillsInterestsFieldInput.unvalidated(),
    this.skillInterestOptions = const [],
    required this.userPreference,
    required this.skillsFormStatus,
  });

  final UserSkillsInterestsFieldInput userSkillsInterestsInput;
  final List<SkillEntity> skillInterestOptions;
  final PreferenceEntity userPreference;
  final SkillsFormStatus skillsFormStatus;

  SkillsFormState copyWith({
    UserSkillsInterestsFieldInput? userSkillsInterestsInput,
    List<SkillEntity>? skillInterestOptions,
    PreferenceEntity? userPreference,
    SkillsFormStatus? skillsFormStatus,
  }) {
    return SkillsFormState(
      userSkillsInterestsInput:
          userSkillsInterestsInput ?? this.userSkillsInterestsInput,
      skillInterestOptions: skillInterestOptions ?? this.skillInterestOptions,
      userPreference: userPreference ?? this.userPreference,
      skillsFormStatus: skillsFormStatus ?? this.skillsFormStatus,
    );
  }

  @override
  List<Object?> get props => [
        userSkillsInterestsInput,
        skillInterestOptions,
        userPreference,
        skillsFormStatus,
      ];
}

enum SkillsFormStatus {
  initial,
  loading,
  success,
  error,
}

class SkillsFormCubit extends Cubit<SkillsFormState> {
  SkillsFormCubit({
    required this.commonRepository,
    required this.userRepository,
    required PreferenceEntity userPreference,
  }) : super(
          SkillsFormState(
            userSkillsInterestsInput: UserSkillsInterestsFieldInput.unvalidated(
              userPreference.skillsInterests,
            ),
            userPreference: userPreference,
            skillsFormStatus: SkillsFormStatus.initial,
          ),
        );

  final CommonRepository commonRepository;
  final UserRepository userRepository;

  Future<void> handleGetSkillsInterests(String? filter) async {
    try {
      final List<SkillEntity> skillInterestOptions =
          await commonRepository.getSkillsInterestsFromEmsi(filter);

      emit(state.copyWith(skillInterestOptions: skillInterestOptions));
    } on Exception catch (error) {
      print(error);
    }
  }

  void onUserSkillsInterestsChanged(List<SkillEntity> val) {
    final newUserSkillsInterestsInputState =
        UserSkillsInterestsFieldInput.validated(val);

    final newState = state.copyWith(
      userSkillsInterestsInput: newUserSkillsInterestsInputState,
    );

    emit(newState);
  }

  Future<void> handleSubmit() async {
    final userSkillsInterestsFieldInput =
        UserSkillsInterestsFieldInput.validated(
            state.userSkillsInterestsInput.value);

    final isFormValid = Formz.validate([
      userSkillsInterestsFieldInput,
    ]);

    if (!isFormValid) {
      emit(state.copyWith(
          userSkillsInterestsInput: userSkillsInterestsFieldInput));
      return;
    }

    try {
      emit(state.copyWith(
        skillsFormStatus: SkillsFormStatus.loading,
      ));
      await userRepository.updateUserSkills(
        UpdateUserSkillsRequest(
          userPreference: state.userPreference.copyWith(
            skillsInterests: state.userSkillsInterestsInput.value,
          ),
        ),
      );

      emit(state.copyWith(
        skillsFormStatus: SkillsFormStatus.success,
      ));
    } on Exception catch (_) {
      emit(state.copyWith(
        skillsFormStatus: SkillsFormStatus.error,
      ));
    }
  }
}
