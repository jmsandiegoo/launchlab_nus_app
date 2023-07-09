import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/checkbox_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/picture_upload_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/end_date_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/start_date_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_skills_interests_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@immutable
class EditCreateTeamState extends Equatable {
  const EditCreateTeamState({
    this.pictureUploadInput = const PictureUploadPickerInput.unvalidated(),
    this.teamNameInput = const TextFieldInput.unvalidated(),
    this.descriptionInput = const TextFieldInput.unvalidated(),
    this.startDateInput = const StartDateFieldInput.unvalidated(),
    this.endDateInput = const EndDateFieldInput.unvalidated(),
    this.isChecked = const CheckboxFieldInput.unvalidated(),
    this.categoryInput = 'School',
    this.commitmentInput = 'Low',
    this.maxMemberInput = const TextFieldInput.unvalidated(),
    this.interestInput = const UserSkillsInterestsFieldInput.unvalidated(),
    this.skillInterestOptions = const [],
    this.avatarURL = '',
    this.isLoaded = false,
  });

  final PictureUploadPickerInput pictureUploadInput;
  final TextFieldInput teamNameInput;
  final TextFieldInput descriptionInput;
  final StartDateFieldInput startDateInput;
  final EndDateFieldInput endDateInput;
  final CheckboxFieldInput isChecked;
  final String categoryInput;
  final String commitmentInput;
  final TextFieldInput maxMemberInput;
  final UserSkillsInterestsFieldInput interestInput;
  final List<SkillEntity> skillInterestOptions;
  final String avatarURL;
  final bool isLoaded;

  EditCreateTeamState copyWith(
      {PictureUploadPickerInput? pictureUploadInput,
      TextFieldInput? teamNameInput,
      TextFieldInput? descriptionInput,
      StartDateFieldInput? startDateInput,
      EndDateFieldInput? endDateInput,
      CheckboxFieldInput? isChecked,
      String? categoryInput,
      String? commitmentInput,
      TextFieldInput? maxMemberInput,
      UserSkillsInterestsFieldInput? interestInput,
      List<SkillEntity>? skillInterestOptions,
      String? avatarURL,
      bool? isLoaded}) {
    return EditCreateTeamState(
        pictureUploadInput: pictureUploadInput ?? this.pictureUploadInput,
        teamNameInput: teamNameInput ?? this.teamNameInput,
        descriptionInput: descriptionInput ?? this.descriptionInput,
        startDateInput: startDateInput ?? this.startDateInput,
        endDateInput: endDateInput ?? this.endDateInput,
        isChecked: isChecked ?? this.isChecked,
        categoryInput: categoryInput ?? this.categoryInput,
        commitmentInput: commitmentInput ?? this.commitmentInput,
        maxMemberInput: maxMemberInput ?? this.maxMemberInput,
        interestInput: interestInput ?? this.interestInput,
        skillInterestOptions: skillInterestOptions ?? this.skillInterestOptions,
        avatarURL: avatarURL ?? this.avatarURL,
        isLoaded: isLoaded ?? this.isLoaded);
  }

  @override
  List<Object?> get props => [
        teamNameInput,
        descriptionInput,
        startDateInput,
        endDateInput,
        isChecked,
        categoryInput,
        commitmentInput,
        maxMemberInput,
        interestInput,
        skillInterestOptions,
        avatarURL
      ];
}

class EditCreateTeamCubit extends Cubit<EditCreateTeamState> {
  EditCreateTeamCubit(this._commonRepository, this._teamRepository)
      : super(const EditCreateTeamState());

  final CommonRepository _commonRepository;
  final TeamRepository _teamRepository;

  // ====================================================================
  // Input handlers
  // ====================================================================

  void onPictureUploadChanged(File? image) {
    final prevState = state;
    final prevPictureUploadInputState = prevState.pictureUploadInput;

    final shouldValidate = prevPictureUploadInputState.isNotValid;

    final newPictureUploadInputState = shouldValidate
        ? PictureUploadPickerInput.validated(image)
        : PictureUploadPickerInput.unvalidated(image);

    final newState =
        state.copyWith(pictureUploadInput: newPictureUploadInputState);

    emit(newState);
  }

  void onTeamNameChanged(String val) {
    final prevState = state;
    final prevInputState = prevState.teamNameInput;

    final shouldValidate = prevInputState.isNotValid;

    final newInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(teamNameInput: newInputState);

    emit(newState);
  }

  void onDescriptionChanged(String val) {
    final prevState = state;
    final prevInputState = prevState.descriptionInput;

    final shouldValidate = prevInputState.isNotValid;

    final newInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(descriptionInput: newInputState);

    emit(newState);
  }

  void onStartDateChanged(DateTime? val) {
    final prevState = state;

    final newStartDateInputState = StartDateFieldInput.validated(val);

    final newEndDateInputState = EndDateFieldInput.validated(
        isPresent: prevState.isChecked.value,
        startDateFieldVal: val,
        value: prevState.endDateInput.value);

    final newState = state.copyWith(
        startDateInput: newStartDateInputState,
        endDateInput: newEndDateInputState);
    emit(newState);
  }

  void onEndDateChanged(DateTime? val) {
    final newEndDateInputState = EndDateFieldInput.validated(
        isPresent: state.isChecked.value,
        startDateFieldVal: state.startDateInput.value,
        value: val);

    final newState = state.copyWith(
      endDateInput: newEndDateInputState,
    );
    emit(newState);
  }

  void onIsCheckedChanged(bool val) {
    final prevState = state;
    final newisCheckedInputState = CheckboxFieldInput.validated(val);
    final prevEndDateInputState = prevState.endDateInput;

    final newEndDateInputState = EndDateFieldInput.unvalidated(
        isPresent: val, value: val ? null : prevEndDateInputState.value);

    final newState = state.copyWith(
      isChecked: newisCheckedInputState,
      endDateInput: newEndDateInputState,
    );

    emit(newState);
  }

  void onCategoryChanged(String val) {
    final newState = state.copyWith(categoryInput: val);
    emit(newState);
  }

  void onCommitmentChanged(String val) {
    final newState = state.copyWith(commitmentInput: val);
    emit(newState);
  }

  void onMaxMemberChanged(String val) {
    final prevState = state;
    final prevInputState = prevState.maxMemberInput;

    final shouldValidate = prevInputState.isNotValid;

    final newInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(maxMemberInput: newInputState);
    emit(newState);
  }

  Future<void> handleGetSkillsInterests(String? filter) async {
    try {
      final List<SkillEntity> skillInterestOptions =
          await _commonRepository.getSkillsInterestsFromEmsi(filter);
      emit(state.copyWith(skillInterestOptions: skillInterestOptions));
    } on Exception catch (error) {
      print(error);
    }
  }

  void onInterestChanged(List<SkillEntity> val) {
    final newInputState = UserSkillsInterestsFieldInput.validated(val);
    final newState = state.copyWith(interestInput: newInputState);
    emit(newState);
  }

  // ====================================================================
  // General handlers
  // ====================================================================

  bool finish() {
    final teamNameInput = TextFieldInput.validated(state.teamNameInput.value);
    final descriptionInput =
        TextFieldInput.validated(state.descriptionInput.value);
    final StartDateFieldInput startDateInput =
        StartDateFieldInput.validated(state.startDateInput.value);
    final EndDateFieldInput endDateInput = EndDateFieldInput.validated(
      isPresent: state.isChecked.value,
      startDateFieldVal: state.startDateInput.value,
      value: state.endDateInput.value,
    );
    final CheckboxFieldInput isChecked =
        CheckboxFieldInput.validated(state.isChecked.value);
    final maxMemberInput = TextFieldInput.validated(state.maxMemberInput.value);
    final interestInput =
        UserSkillsInterestsFieldInput.validated(state.interestInput.value);

    final isFormValid = Formz.validate([
      teamNameInput,
      descriptionInput,
      startDateInput,
      endDateInput,
      isChecked,
      maxMemberInput,
      interestInput
    ]);

    if (!isFormValid) {
      emit(state.copyWith(
          teamNameInput: teamNameInput,
          descriptionInput: descriptionInput,
          startDateInput: startDateInput,
          endDateInput: endDateInput,
          isChecked: isChecked,
          maxMemberInput: maxMemberInput,
          interestInput: interestInput));
    }
    return isFormValid;
  }

  // ====================================================================
  // Database calls
  // ====================================================================

  final supabase = Supabase.instance.client;
  getData(teamId) async {
    final TeamEntity res = await _teamRepository.getEditCreateTeamData(teamId);
    final newTeamNameState = TextFieldInput.validated(res.teamName);
    final newDescriptionState = TextFieldInput.validated(res.description);
    final newStartDateState = StartDateFieldInput.validated(res.startDate);
    final newMaxMemberState =
        TextFieldInput.validated(res.maxMembers.toString());
    List<SkillEntity> allInterest = [];
    res.interest.forEach((interest) {
      allInterest.add(
          SkillEntity(emsiId: interest['emsi_id'], name: interest['name']));
    });
    final newInterestInput =
        UserSkillsInterestsFieldInput.validated(allInterest);

    res.endDate == null
        ? onIsCheckedChanged(true)
        : onEndDateChanged(res.endDate);

    final newState = state.copyWith(
        teamNameInput: newTeamNameState,
        descriptionInput: newDescriptionState,
        startDateInput: newStartDateState,
        categoryInput: res.category,
        commitmentInput: res.commitment,
        maxMemberInput: newMaxMemberState,
        interestInput: newInterestInput,
        avatarURL: res.avatarURL,
        isLoaded: true);
    emit(newState);
  }

  updateTeamData({
    teamId,
    teamName,
    description,
    startDate,
    endDate,
    category,
    commitment,
    maxMember,
    interest,
    avatar,
  }) async {
    _teamRepository.updateTeamData(
        teamId: teamId,
        teamName: teamName,
        description: description,
        startDate: startDate,
        endDate: endDate,
        category: category,
        commitment: commitment,
        maxMember: maxMember,
        interest: interest,
        avatar: avatar);
    debugPrint("Edited Team Data Saved");
  }

  //Create a save team data class next time
  createNewTeam(
      {userId,
      teamName,
      description,
      startDate,
      endDate,
      category,
      commitment,
      maxMember,
      interest,
      avatar}) async {
    List<String> interestName = [];
    interest.forEach((value) {
      interestName.add(value.name);
    });

    _teamRepository.createNewTeam(
        userId: userId,
        teamName: teamName,
        description: description,
        startDate: startDate,
        endDate: endDate,
        category: category,
        commitment: commitment,
        maxMember: maxMember,
        interest: interest,
        interestName: interestName,
        avatar: avatar);

    debugPrint("New Team Created");
  }
}
