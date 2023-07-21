import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/create_user_experience_request.dart';
import 'package:launchlab/src/domain/user/models/requests/delete_user_experience_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_experience_request.dart';
import 'package:launchlab/src/domain/user/models/responses/create_user_experiences_response.dart';
import 'package:launchlab/src/domain/user/models/responses/update_user_experience_response.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/checkbox_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/user/cubits/experience_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/end_date_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/start_date_field.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
  });

  group("[Profile] ExperienceFormCubit Test:", () {
    final ExperienceEntity experience = ExperienceEntity(
      title: "test",
      companyName: 'test',
      description: 'test',
      isCurrent: false,
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now(),
      userId: "123",
    );

    final ExperienceFormState initialState = ExperienceFormState(
      experienceFormStatus: ExperienceFormStatus.initial,
      experience: experience,
      titleNameFieldInput: TextFieldInput.unvalidated(experience.title),
      companyNameFieldInput: TextFieldInput.unvalidated(experience.companyName),
      descriptionFieldInput: TextFieldInput.unvalidated(experience.description),
      isCurrentFieldInput: CheckboxFieldInput.unvalidated(experience.isCurrent),
      startDateFieldInput:
          StartDateFieldInput.unvalidated(experience.startDate),
      endDateFieldInput: EndDateFieldInput.unvalidated(
          isPresent: experience.isCurrent, value: experience.endDate),
    );
    blocTest<ExperienceFormCubit, ExperienceFormState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [ExperienceFormStatus.createSuccess, experience] when create experience succesful",
        // define mock behavior for this test case
        setUp: () {
          registerFallbackValue(
              CreateUserExperienceRequest(experience: experience));
          when(() => mockUserRepository.createUserExperience(any()))
              .thenAnswer((_) async => CreateUserExperienceResponse(
                    experience: experience,
                  ));
        },
        // building the cubit including mock behaviors
        build: () => ExperienceFormCubit(
              userRepository: mockUserRepository,
            ),
        // what the cubit should do
        act: (cubit) =>
            cubit.handleSubmit(isEditMode: false, isApiCalled: true),
        seed: () => initialState,
        // after calling method what is the expected state
        expect: () => [
              initialState.copyWith(
                  experienceFormStatus: ExperienceFormStatus.createLoading,
                  experience: experience),
              initialState.copyWith(
                  experienceFormStatus: ExperienceFormStatus.createSuccess,
                  experience: experience),
            ],
        verify: (_) async {
          verify(() => mockUserRepository.createUserExperience(any()))
              .called(1);
        });

    blocTest<ExperienceFormCubit, ExperienceFormState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [ExperienceFormStatus.createSuccess, experience] when create experience locally succesful",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => ExperienceFormCubit(
        userRepository: mockUserRepository,
      ),
      // what the cubit should do
      act: (cubit) => cubit.handleSubmit(isEditMode: false, isApiCalled: false),
      seed: () => initialState,
      // after calling method what is the expected state
      expect: () => [
        initialState.copyWith(
          experience: experience,
          experienceFormStatus: ExperienceFormStatus.createSuccess,
        ),
      ],
    );

    blocTest<ExperienceFormCubit, ExperienceFormState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [ExperienceFormStatus.updateSuccess, experience] when update experience succesful",
        // define mock behavior for this test case
        setUp: () {
          registerFallbackValue(
              UpdateUserExperienceRequest(experience: experience));
          when(() => mockUserRepository.updateUserExperience(any()))
              .thenAnswer((_) async => UpdateUserExperienceResponse(
                    experience: experience,
                  ));
        },
        // building the cubit including mock behaviors
        build: () => ExperienceFormCubit(
              userRepository: mockUserRepository,
            ),
        // what the cubit should do
        act: (cubit) => cubit.handleSubmit(isEditMode: true, isApiCalled: true),
        seed: () => initialState,
        // after calling method what is the expected state
        expect: () => [
              initialState.copyWith(
                  experienceFormStatus: ExperienceFormStatus.updateLoading,
                  experience: experience),
              initialState.copyWith(
                  experienceFormStatus: ExperienceFormStatus.updateSuccess,
                  experience: experience),
            ],
        verify: (_) async {
          verify(() => mockUserRepository.updateUserExperience(any()))
              .called(1);
        });

    blocTest<ExperienceFormCubit, ExperienceFormState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [ExperienceFormStatus.updateSuccess, experience] when update experience locally succesful",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => ExperienceFormCubit(
        userRepository: mockUserRepository,
      ),
      // what the cubit should do
      act: (cubit) => cubit.handleSubmit(isEditMode: true, isApiCalled: false),
      seed: () => initialState,
      // after calling method what is the expected state
      expect: () => [
        initialState.copyWith(
            experienceFormStatus: ExperienceFormStatus.updateSuccess,
            experience: experience),
      ],
    );

    blocTest<ExperienceFormCubit, ExperienceFormState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [ExperienceFormStatus.deleteSuccess] when delete experience succesful",
      // define mock behavior for this test case
      setUp: () {
        registerFallbackValue(
            DeleteUserExperienceRequest(experience: experience));
        when(() => mockUserRepository.deleteUserExperience(any()))
            .thenAnswer((_) async {});
      },
      // building the cubit including mock behaviors
      build: () => ExperienceFormCubit(
        userRepository: mockUserRepository,
      ),
      // what the cubit should do
      act: (cubit) => cubit.handleDelete(isApiCalled: true),
      seed: () => initialState,
      // after calling method what is the expected state
      expect: () => [
        initialState.copyWith(
          experienceFormStatus: ExperienceFormStatus.deleteLoading,
        ),
        initialState.copyWith(
          experienceFormStatus: ExperienceFormStatus.deleteSuccess,
        ),
      ],
    );

    blocTest<ExperienceFormCubit, ExperienceFormState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [ExperienceFormStatus.deleteSuccess] when delete experience locally succesful",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => ExperienceFormCubit(
        userRepository: mockUserRepository,
      ),
      // what the cubit should do
      act: (cubit) => cubit.handleDelete(isApiCalled: false),
      seed: () => initialState,
      // after calling method what is the expected state
      expect: () => [
        initialState.copyWith(
          experienceFormStatus: ExperienceFormStatus.deleteSuccess,
        ),
      ],
    );
  });
}
