import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/checkbox_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/picture_upload_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/end_date_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/start_date_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_skills_interests_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

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
      String? avatarURL}) {
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
        avatarURL: avatarURL ?? this.avatarURL);
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
  EditCreateTeamCubit(this._commonRepository)
      : super(const EditCreateTeamState());

  final CommonRepository _commonRepository;

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

  void initState(
      {teamName,
      description,
      startDate,
      endDate,
      category,
      commitment,
      maxMember,
      interest,
      avatar,
      avatarURL}) {
    final newTeamNameState = TextFieldInput.validated(teamName);
    final newDescriptionState = TextFieldInput.validated(description);
    final newStartDateState =
        StartDateFieldInput.validated(DateTime.parse(startDate));

    final newMaxMemberState = TextFieldInput.validated(maxMember.toString());

    final newPictureUploadInputState =
        PictureUploadPickerInput.validated(avatar);

    List<SkillEntity> allInterest = [];
    interest.forEach((interest) {
      allInterest.add(
          SkillEntity(emsiId: interest['emsi_id'], name: interest['name']));
    });

    final newInterestInput =
        UserSkillsInterestsFieldInput.validated(allInterest);

    final newState = state.copyWith(
        teamNameInput: newTeamNameState,
        descriptionInput: newDescriptionState,
        startDateInput: newStartDateState,
        categoryInput: category,
        commitmentInput: commitment,
        maxMemberInput: newMaxMemberState,
        interestInput: newInterestInput,
        pictureUploadInput: newPictureUploadInputState,
        avatarURL: avatarURL);
    emit(newState);
  }

  // ====================================================================
  // Database calls
  // ====================================================================

  final supabase = Supabase.instance.client;
  getData(teamId) async {
    var teamData = await supabase.from('teams').select().eq('id', teamId);

    var avatarURL = teamData[0]['avatar'] == null
        ? ''
        : await supabase.storage
            .from('team_avatar_bucket')
            .createSignedUrl('${teamData[0]['avatar']}', 30);
    teamData[0]['avatar_url'] = avatarURL;

    return teamData[0];
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
    await supabase.from('teams').update({
      'team_name': teamName,
      'description': description,
      'start_date': startDate,
      'end_date': endDate == '' ? null : endDate,
      'project_category': category,
      'commitment': commitment,
      'max_members': maxMember,
      'interest': interest,
      'updated_at': DateTime.now().toString()
    }).eq('id', teamId);
    debugPrint("Edited Team Data Saved");
  }

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
    var teamId = const Uuid().v4();
    await supabase.from('teams').insert({
      'id': teamId,
      'team_name': teamName,
      'description': description,
      'start_date': startDate,
      'end_date': endDate == '' ? null : endDate,
      'project_category': category,
      'commitment': commitment,
      'current_members': 1,
      'max_members': maxMember,
      'interest': interest,
      'avatar': avatar.toString() == 'null'
          ? null
          : '${teamId}_avatar${avatar.toString().substring(avatar.toString().indexOf('.'))}',
    });

    avatar.toString() == 'null'
        ? debugPrint('No Picture Uploaded')
        : await supabase.storage.from('team_avatar_bucket').upload(
            '${teamId}_avatar${avatar.toString().substring(avatar.toString().indexOf('.'))}',
            avatar,
            fileOptions:
                const FileOptions(cacheControl: '3600', upsert: false));

    await supabase.from('team_users').insert({
      'user_id': userId,
      'team_id': teamId,
      'is_owner': true,
      'position': 'Owner'
    });

    debugPrint("New Team Created");
  }
}
