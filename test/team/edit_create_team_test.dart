import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/checkbox_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/picture_upload_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/team/cubits/edit_create_team_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/end_date_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/start_date_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_skills_interests_field.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:mocktail/mocktail.dart';

import 'package:launchlab/src/data/team/team_repository.dart';

class MockTeamRepository extends Mock implements TeamRepository {}

class MockCommonRepository extends Mock implements CommonRepository {}

class MockFile extends Mock implements File {}

void main() {
  late MockTeamRepository mockTeamRepository;
  late EditCreateTeamCubit editCreateTeamCubit;
  late MockCommonRepository mockCommonRepository;

  group("Create Edit Team Cubit", () {
    setUp(() async {
      mockTeamRepository = MockTeamRepository();
      mockCommonRepository = MockCommonRepository();

      editCreateTeamCubit =
          EditCreateTeamCubit(mockCommonRepository, mockTeamRepository);
    });

    final Failure failure = Failure.request();
    const String teamId = '2ebb33bb-0da1-450c-91c4-51f8befd57d1';

    TeamEntity teamData = TeamEntity(
        '',
        '',
        '',
        1,
        1,
        DateTime.tryParse('2023-08-20')!,
        DateTime.tryParse('2023-08-20'),
        'Low',
        'School',
        const [],
        null,
        '',
        false,
        true,
        const []);

    blocTest<EditCreateTeamCubit, EditCreateTeamState>(
      'emits [EditCreateStatus.loading, teamNameInput, descriptionInput, EditCreateStatus.success, etc..] when data is loaded.',
      setUp: () => when(() => mockTeamRepository.getEditCreateTeamData(teamId))
          .thenAnswer((_) async => teamData),
      build: () => editCreateTeamCubit,
      act: (cubit) => cubit.getData(teamId),
      expect: () => <EditCreateTeamState>[
        EditCreateTeamState(
            endDateInput: EndDateFieldInput.validated(
                isPresent: true,
                startDateFieldVal: DateTime.now(),
                value: DateTime.tryParse('2023-08-20')),
            status: EditCreateStatus.loading),
        EditCreateTeamState(
            teamNameInput: TextFieldInput.validated(teamData.teamName),
            descriptionInput: TextFieldInput.validated(teamData.description),
            startDateInput:
                StartDateFieldInput.validated(DateTime.tryParse('2023-08-20')),
            categoryInput: teamData.category,
            commitmentInput: teamData.commitment,
            maxMemberInput:
                TextFieldInput.validated(teamData.maxMembers.toString()),
            interestInput: const UserSkillsInterestsFieldInput.validated(),
            avatarURL: teamData.avatarURL,
            endDateInput: EndDateFieldInput.validated(
                isPresent: true,
                startDateFieldVal: DateTime.tryParse('2023-08-20'),
                value: DateTime.tryParse('2023-08-20')),
            isChecked: const CheckboxFieldInput.unvalidated(),
            status: EditCreateStatus.success),
      ],
      verify: (_) async {
        verify(() => mockTeamRepository.getEditCreateTeamData(teamId))
            .called(1);
      },
    );

    blocTest<EditCreateTeamCubit, EditCreateTeamState>(
      'emits [EditCreateStatus.error] when failure is caught.',
      setUp: () => when(() => mockTeamRepository.getEditCreateTeamData(teamId))
          .thenThrow(failure),
      build: () => editCreateTeamCubit,
      act: (cubit) => cubit.getData(teamId),
      expect: () => <EditCreateTeamState>[
        EditCreateTeamState(status: EditCreateStatus.error, error: failure),
      ],
      verify: (_) async {
        verify(() => mockTeamRepository.getEditCreateTeamData(teamId))
            .called(1);
      },
    );

    final File mockFile = MockFile();

    blocTest<EditCreateTeamCubit, EditCreateTeamState>(
      "emits [newPictureUploadInputState] when profile picture changes",
      setUp: () {},
      build: () => editCreateTeamCubit,
      act: (cubit) => cubit.onPictureUploadChanged(mockFile),
      expect: () => [
        EditCreateTeamState(
          pictureUploadInput: PictureUploadPickerInput.unvalidated(mockFile),
        )
      ],
    );

    blocTest<EditCreateTeamCubit, EditCreateTeamState>(
      "emits [newTeamNameInputState] when team name changes",
      setUp: () {},
      build: () => editCreateTeamCubit,
      act: (cubit) => cubit.onTeamNameChanged("Team"),
      expect: () => [
        const EditCreateTeamState(
          teamNameInput: TextFieldInput.validated("Team"),
        )
      ],
    );

    blocTest<EditCreateTeamCubit, EditCreateTeamState>(
      "emits [newDescriptionInputState] when description changes",
      setUp: () {},
      build: () => editCreateTeamCubit,
      act: (cubit) => cubit.onDescriptionChanged("Team"),
      expect: () => [
        const EditCreateTeamState(
          descriptionInput: TextFieldInput.validated("Team"),
        )
      ],
    );

    blocTest<EditCreateTeamCubit, EditCreateTeamState>(
      "emits [newStartDateInputState] when start date changes",
      setUp: () {},
      build: () => editCreateTeamCubit,
      act: (cubit) => cubit.onStartDateChanged(DateTime.tryParse('2023-08-20')),
      expect: () => [
        EditCreateTeamState(
            startDateInput:
                StartDateFieldInput.validated(DateTime.tryParse('2023-08-20')),
            endDateInput: EndDateFieldInput.validated(
                isPresent: false,
                startDateFieldVal: DateTime.now(),
                value: null))
      ],
    );

    blocTest<EditCreateTeamCubit, EditCreateTeamState>(
      "emits [newEndDateInputState] when end date changes",
      setUp: () {},
      build: () => editCreateTeamCubit,
      act: (cubit) => cubit.onEndDateChanged(DateTime.tryParse('2023-08-20')),
      expect: () => [
        EditCreateTeamState(
            endDateInput: EndDateFieldInput.validated(
                isPresent: false,
                startDateFieldVal: DateTime.now(),
                value: DateTime.tryParse('2023-08-20')))
      ],
    );

    blocTest<EditCreateTeamCubit, EditCreateTeamState>(
      "emits [newIsCheckedState] when no end date is checked changes",
      setUp: () {},
      build: () => editCreateTeamCubit,
      act: (cubit) => cubit.onIsCheckedChanged(true),
      expect: () => [
        const EditCreateTeamState(
          isChecked: CheckboxFieldInput.validated(true),
          endDateInput:
              EndDateFieldInput.unvalidated(isPresent: true, value: null),
        )
      ],
    );

    blocTest<EditCreateTeamCubit, EditCreateTeamState>(
      "emits [newOnCategoryChangedState] when project category changes",
      setUp: () {},
      build: () => editCreateTeamCubit,
      act: (cubit) => cubit.onCategoryChanged('Personal'),
      expect: () => [const EditCreateTeamState(categoryInput: 'Personal')],
    );

    blocTest<EditCreateTeamCubit, EditCreateTeamState>(
      "emits [newOnCommitmentChangedState] when commitment changes",
      setUp: () {},
      build: () => editCreateTeamCubit,
      act: (cubit) => cubit.onCommitmentChanged('High'),
      expect: () => [const EditCreateTeamState(commitmentInput: 'High')],
    );

    blocTest<EditCreateTeamCubit, EditCreateTeamState>(
      "emits [newMaxMemberInputState] when max member changes",
      setUp: () {},
      build: () => editCreateTeamCubit,
      act: (cubit) => cubit.onMaxMemberChanged("3"),
      expect: () => [
        const EditCreateTeamState(
          maxMemberInput: TextFieldInput.validated("3"),
        )
      ],
    );

    final List<SkillEntity> skillsInterestsData = [
      const SkillEntity(
          emsiId: "KSDJCA4E89LB98JAZ7LZ",
          name: "React.js (Javascript Library)"),
    ];

    blocTest<EditCreateTeamCubit, EditCreateTeamState>(
        "emits [skillInterestOptions] when get skills interests successful",
        setUp: () {
          when(() => mockCommonRepository.getSkillsInterestsFromEmsi(any()))
              .thenAnswer((invocation) async => skillsInterestsData);
        },
        build: () => editCreateTeamCubit,
        act: (cubit) => cubit.handleGetSkillsInterests("test"),
        expect: () =>
            [EditCreateTeamState(skillInterestOptions: skillsInterestsData)],
        verify: (_) async {
          verify(() => mockCommonRepository.getSkillsInterestsFromEmsi(any()))
              .called(1);
        });

    blocTest<EditCreateTeamCubit, EditCreateTeamState>(
      "emits [newOnInterestChangedState] when interests changes",
      setUp: () {},
      build: () => editCreateTeamCubit,
      act: (cubit) => cubit.onInterestChanged(skillsInterestsData),
      expect: () => [
        EditCreateTeamState(
            interestInput:
                UserSkillsInterestsFieldInput.validated(skillsInterestsData))
      ],
    );

    blocTest<EditCreateTeamCubit, EditCreateTeamState>(
      "emits [previousFormState] when the form is not validated",
      setUp: () {},
      build: () => editCreateTeamCubit,
      act: (cubit) => cubit.finish(),
      expect: () => [
        const EditCreateTeamState(
            teamNameInput: TextFieldInput.validated(),
            descriptionInput: TextFieldInput.validated(),
            startDateInput: StartDateFieldInput.validated(),
            endDateInput: EndDateFieldInput.validated(
                isPresent: false, startDateFieldVal: null, value: null),
            isChecked: CheckboxFieldInput.validated(),
            categoryInput: 'School',
            commitmentInput: 'Low',
            maxMemberInput: TextFieldInput.validated(),
            interestInput: UserSkillsInterestsFieldInput.validated(),
            skillInterestOptions: [])
      ],
    );
  });
}
