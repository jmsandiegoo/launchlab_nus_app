import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_skills_request.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/user/cubits/about_form_cubit.dart';
import 'package:launchlab/src/presentation/user/cubits/skills_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_skills_interests_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/username_field.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:mocktail/mocktail.dart';

class MockUserNameFieldInput extends Mock implements UsernameFieldInput {}

class MockUserRepository extends Mock implements UserRepository {}

class MockCommonRepository extends Mock implements CommonRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late MockCommonRepository mockCommonRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockCommonRepository = MockCommonRepository();
  });

  group("[Profile] SkillsFormCubit Test:", () {
    final List<SkillEntity> skillsInterestsData = [
      const SkillEntity(emsiId: "123", name: "test"),
    ];

    final PreferenceEntity preference = PreferenceEntity(
        skillsInterests: skillsInterestsData, categories: const []);

    final SkillsFormState initialState = SkillsFormState(
      userSkillsInterestsInput: UserSkillsInterestsFieldInput.unvalidated(
        preference.skillsInterests,
      ),
      skillInterestOptions: const [],
      userPreference: preference,
      skillsFormStatus: SkillsFormStatus.initial,
    );

    blocTest<SkillsFormCubit, SkillsFormState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [skillInterestOptions] when get skills interests successful",
        // define mock behavior for this test case
        setUp: () {
          when(() => mockCommonRepository.getSkillsInterestsFromEmsi(any()))
              .thenAnswer((_) async => skillsInterestsData);
        },
        // building the cubit including mock behaviors
        build: () => SkillsFormCubit(
              userRepository: mockUserRepository,
              commonRepository: mockCommonRepository,
              userPreference: preference,
            ),
        // what the cubit should do
        act: (cubit) => cubit.handleGetSkillsInterests("test"),
        // after calling method what is the expected state
        expect: () => [
              initialState.copyWith(
                skillInterestOptions: skillsInterestsData,
              ),
            ],
        verify: (_) async {
          verify(() => mockCommonRepository.getSkillsInterestsFromEmsi(any()))
              .called(1);
        });

    blocTest<SkillsFormCubit, SkillsFormState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [introFormStatus.success] when submit succesful",
        // define mock behavior for this test case
        setUp: () {
          registerFallbackValue(
              UpdateUserSkillsRequest(userPreference: preference));
          when(() => mockUserRepository.updateUserSkills(any()))
              .thenAnswer((_) async {});
        },
        // building the cubit including mock behaviors
        build: () => SkillsFormCubit(
              userRepository: mockUserRepository,
              commonRepository: mockCommonRepository,
              userPreference: preference,
            ),
        // what the cubit should do
        act: (cubit) => cubit.handleSubmit(),
        // after calling method what is the expected state
        expect: () => [
              initialState.copyWith(
                skillsFormStatus: SkillsFormStatus.loading,
              ),
              initialState.copyWith(
                skillsFormStatus: SkillsFormStatus.success,
              ),
            ],
        verify: (_) async {
          verify(() => mockUserRepository.updateUserSkills(any())).called(1);
        });

    final Failure failure =
        Failure.request(message: "Failed to update user skills interests");

    blocTest<SkillsFormCubit, SkillsFormState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [introFormStatus.success] when submit fails",
        // define mock behavior for this test case
        setUp: () {
          registerFallbackValue(
              UpdateUserSkillsRequest(userPreference: preference));
          when(() => mockUserRepository.updateUserSkills(any()))
              .thenThrow(failure);
        },
        // building the cubit including mock behaviors
        build: () => SkillsFormCubit(
              userRepository: mockUserRepository,
              commonRepository: mockCommonRepository,
              userPreference: preference,
            ),
        // what the cubit should do
        act: (cubit) => cubit.handleSubmit(),
        // after calling method what is the expected state
        expect: () => [
              initialState.copyWith(
                skillsFormStatus: SkillsFormStatus.loading,
              ),
              initialState.copyWith(
                skillsFormStatus: SkillsFormStatus.error,
                error: failure,
              ),
            ],
        verify: (_) async {
          verify(() => mockUserRepository.updateUserSkills(any())).called(1);
        });

    blocTest<SkillsFormCubit, SkillsFormState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [aboutInput] when form inputs are invalid",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => SkillsFormCubit(
        userRepository: mockUserRepository,
        commonRepository: mockCommonRepository,
        userPreference: preference,
      ),
      seed: () => initialState.copyWith(
        userSkillsInterestsInput:
            const UserSkillsInterestsFieldInput.unvalidated(),
      ),
      // what the cubit should do
      act: (cubit) => cubit.handleSubmit(),
      // after calling method what is the expected state
      expect: () => [
        initialState.copyWith(
          userSkillsInterestsInput:
              const UserSkillsInterestsFieldInput.validated(),
        ),
      ],
    );
  });
}
