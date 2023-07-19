import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/common/models/category_entity.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/onboard_user_request.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/picture_upload_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/accomplishments_list_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/degree_programme_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/experience_list_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_preferred_category_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_resume_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_skills_interests_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/username_field.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:mocktail/mocktail.dart';

class MockCommonRepository extends Mock implements CommonRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockFile extends Mock implements File {}

void main() {
  late MockUserRepository mockUserRepository;
  late CommonRepository mockCommonRepository;

  setUp(() async {
    mockUserRepository = MockUserRepository();
    mockCommonRepository = MockCommonRepository();
  });

  group("OnboardingCubit Test:", () {
    // test data
    final user = UserEntity(
      id: "1",
      firstName: "Test",
      lastName: "Account",
      title: "Title",
      about: "About",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      degreeProgrammeId: "test",
      isOnboarded: true,
      username: 'testusername',
    );

    /// mockDegreeProgrammes data
    final List<DegreeProgrammeEntity> degreeProgrammes = [
      const DegreeProgrammeEntity(
          id: "123",
          type: "Undegraduate",
          name: "Bachelor in Computer Science"),
      const DegreeProgrammeEntity(
          id: "456",
          type: "Undergraduate",
          name: "Bachelor in Business Analytics")
    ];

    blocTest<OnboardingCubit, OnboardingState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [degreeProgrammeOptions] when get degree programmes successful",
        // define mock behavior for this test case
        setUp: () {
          // stub method
          when(() => mockUserRepository.getDegreeProgrammes(any()))
              .thenAnswer((invocation) async => degreeProgrammes);
        },
        // building the cubit including mock behaviors
        build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
        // what the cubit should do
        act: (cubit) => cubit.handleGetDegreeProgrammes("test"),
        // after calling method what is the expected state
        expect: () => [
              OnboardingState(
                degreeProgrammeOptions: degreeProgrammes,
              ),
            ],
        verify: (_) async {
          verify(() => mockUserRepository.getDegreeProgrammes(any())).called(1);
        });

    /// mockFile
    final File mockFile = MockFile();

    blocTest<OnboardingCubit, OnboardingState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [newPictureUploadPickerInputState] when profile picture changes",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
      // what the cubit should do
      act: (cubit) => cubit.onPictureUploadChanged(mockFile),
      // after calling method what is the expected state
      expect: () => [
        OnboardingState(
          pictureUploadPickerInput:
              PictureUploadPickerInput.unvalidated(mockFile),
          onboardingStatus: null,
        )
      ],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [newUsernameInputState] when username input changes",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
      // what the cubit should do
      act: (cubit) => cubit.onUsernameChanged("new_username"),
      // after calling method what is the expected state
      expect: () => [
        const OnboardingState(
          usernameInput: UsernameFieldInput.validated("new_username"),
          onboardingStatus: null,
          usernameAsyncError: null,
        )
      ],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [newFirstNameInputState] when first name input changes",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
      // what the cubit should do
      act: (cubit) => cubit.onFirstNameChanged("test"),
      // after calling method what is the expected state
      expect: () => [
        const OnboardingState(
          firstNameInput: TextFieldInput.validated("test"),
          onboardingStatus: null,
        )
      ],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [newLastNameInputState] when last name input changes",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
      // what the cubit should do
      act: (cubit) => cubit.onLastNameChanged("test"),
      // after calling method what is the expected state
      expect: () => [
        const OnboardingState(
          lastNameInput: TextFieldInput.validated("test"),
          onboardingStatus: null,
        )
      ],
    );

    const degree = DegreeProgrammeEntity(
        id: "123", type: "Undegraduate", name: "Bachelor in Computer Science");

    blocTest<OnboardingCubit, OnboardingState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [newDegreeProgrammeInputState] when degree programme input changes",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
      // what the cubit should do
      act: (cubit) => cubit.onDegreeProgrammeChanged(degree),
      // after calling method what is the expected state
      expect: () => [
        const OnboardingState(
          degreeProgrammeInput: DegreeProgrammeFieldInput.validated(degree),
          onboardingStatus: null,
        )
      ],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [newAboutInputState] when about input changes",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
      // what the cubit should do
      act: (cubit) => cubit.onAboutChanged("test"),
      // after calling method what is the expected state
      expect: () => [
        const OnboardingState(
          aboutInput: TextFieldInput.validated("test"),
          onboardingStatus: null,
        )
      ],
    );

    final List<SkillEntity> skillsInterestsData = [
      const SkillEntity(emsiId: "123", name: "test"),
    ];

    blocTest<OnboardingCubit, OnboardingState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [skillInterestOptions] when get skills interests successful",
        // define mock behavior for this test case
        setUp: () {
          // stub method
          when(() => mockCommonRepository.getSkillsInterestsFromEmsi(any()))
              .thenAnswer((invocation) async => skillsInterestsData);
        },
        // building the cubit including mock behaviors
        build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
        // what the cubit should do
        act: (cubit) => cubit.handleGetSkillsInterests("test"),
        // after calling method what is the expected state
        expect: () => [
              OnboardingState(
                skillInterestOptions: skillsInterestsData,
              ),
            ],
        verify: (_) async {
          verify(() => mockCommonRepository.getSkillsInterestsFromEmsi(any()))
              .called(1);
        });

    blocTest<OnboardingCubit, OnboardingState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [newUserSkillsInterestsInputState] when skills interests input changes",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
      // what the cubit should do
      act: (cubit) => cubit.onUserSkillsInterestsChanged(skillsInterestsData),
      // after calling method what is the expected state
      expect: () => [
        OnboardingState(
          userSkillsInterestsInput:
              UserSkillsInterestsFieldInput.validated(skillsInterestsData),
          onboardingStatus: null,
        ),
      ],
    );

    final List<CategoryEntity> categoriesData = [
      const CategoryEntity(id: "123", name: "test"),
      const CategoryEntity(id: "456", name: "test2")
    ];

    blocTest<OnboardingCubit, OnboardingState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [newUserPreferredCategoryInputState] when preferred category input changes",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
      // what the cubit should do
      act: (cubit) => cubit.onUserPreferredCategoryChanged(categoriesData),
      // after calling method what is the expected state
      expect: () => [
        OnboardingState(
          userPreferredCategoryInput:
              UserPreferredCategoryFieldInput.validated(categoriesData),
          onboardingStatus: null,
        ),
      ],
    );

    final mockResumeFile = MockFile();

    blocTest<OnboardingCubit, OnboardingState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [newUserResumeInputState] when resume input changes",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
      // what the cubit should do
      act: (cubit) => cubit.onUserResumeChanged(mockResumeFile),
      // after calling method what is the expected state
      expect: () => [
        OnboardingState(
          userResumeInput: UserResumeFieldInput.validated(mockResumeFile),
          onboardingStatus: null,
        ),
      ],
    );

    final List<ExperienceEntity> experiencesData = [
      ExperienceEntity(
          title: "title",
          companyName: "companyName",
          isCurrent: true,
          startDate: DateTime.now(),
          description: "description"),
    ];

    blocTest<OnboardingCubit, OnboardingState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [newExperienceListInputState] when experience input changes",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
      // what the cubit should do
      act: (cubit) => cubit.onExperienceListChanged(experiencesData),
      // after calling method what is the expected state
      expect: () => [
        OnboardingState(
          experienceListInput:
              ExperienceListFieldInput.validated(experiencesData),
          onboardingStatus: null,
        ),
      ],
    );

    final List<AccomplishmentEntity> accomplishmentsData = [
      AccomplishmentEntity(
          title: "title",
          description: "description",
          isActive: true,
          startDate: DateTime.now(),
          issuer: 'issuer'),
    ];

    blocTest<OnboardingCubit, OnboardingState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [newExperienceListInputState] when accomplishments input changes",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
      // what the cubit should do
      act: (cubit) => cubit.onAccomplishmentListChanged(accomplishmentsData),
      // after calling method what is the expected state
      expect: () => [
        OnboardingState(
          accomplishmentListInput:
              AccomplishmentListFieldInput.validated(accomplishmentsData),
          onboardingStatus: null,
        ),
      ],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [categoryOptions, currStep: 1, OnboardingStatus.nextPage] when initalize form is successful",
      // define mock behavior for this test case
      setUp: () {
        when(() => mockCommonRepository.getCategories())
            .thenAnswer((_) async => categoriesData);
      },
      // building the cubit including mock behaviors
      build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
      // what the cubit should do
      act: (cubit) => cubit.handleInitializeForm(),
      // after calling method what is the expected state
      expect: () => [
        const OnboardingState(
          onboardingStatus: OnboardingStatus.initializing,
        ),
        OnboardingState(
          categoryOptions: categoriesData,
          currStep: 1,
          onboardingStatus: OnboardingStatus.nextPage,
        ),
      ],
      verify: (bloc) {
        verify(() => mockCommonRepository.getCategories()).called(1);
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [OnboardingStatus.submissionSuccess] when onboarding successful",
        // define mock behavior for this test case
        setUp: () {
          registerFallbackValue(OnboardUserRequest(user: user));
          // stub onboard method to succeed
          when(() => mockUserRepository.onboardUser(
              request: any(named: 'request'))).thenAnswer((_) async {});
        },
        // building the cubit including mock behaviors
        build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
        // what the cubit should do
        act: (cubit) => cubit.handleSubmit(user),
        // after calling method what is the expected state
        expect: () => [
              const OnboardingState(
                  onboardingStatus: OnboardingStatus.submissionInProgress),
              const OnboardingState(
                  onboardingStatus: OnboardingStatus.submissionSuccess)
            ],
        verify: (_) async {
          verify(() => mockUserRepository.onboardUser(
              request: any(named: 'request'))).called(1);
        });

    // failure
    final failure = Failure.request(message: "Failed to onboard user");

    blocTest<OnboardingCubit, OnboardingState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [OnboardingStatus.submissionError] when onboarding fails",
        // define mock behavior for this test case
        setUp: () {
          registerFallbackValue(OnboardUserRequest(user: user));

          // stub onboard method to succeed
          when(() => mockUserRepository.onboardUser(
              request: any(named: 'request'))).thenThrow(failure);
        },
        // building the cubit including mock behaviors
        build: () => OnboardingCubit(mockCommonRepository, mockUserRepository),
        // what the cubit should do
        act: (cubit) => cubit.handleSubmit(user),
        // after calling method what is the expected state
        expect: () => [
              const OnboardingState(
                  onboardingStatus: OnboardingStatus.submissionInProgress),
              OnboardingState(
                onboardingStatus: OnboardingStatus.submissionError,
                error: failure,
              )
            ],
        verify: (_) async {
          verify(() => mockUserRepository.onboardUser(
              request: any(named: 'request'))).called(1);
        });
  });
}
