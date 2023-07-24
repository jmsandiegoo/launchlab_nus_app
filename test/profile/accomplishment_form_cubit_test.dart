import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/create_user_accomplishment_request.dart';
import 'package:launchlab/src/domain/user/models/requests/delete_user_accomplishment_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_accomplishment_request.dart';
import 'package:launchlab/src/domain/user/models/responses/create_user_accomplishment_response.dart';
import 'package:launchlab/src/domain/user/models/responses/update_user_accomplishment_response.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/checkbox_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/user/cubits/accomplishment_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/end_date_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/start_date_field.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
  });

  group("[Profile] AccomplishmentFormCubit Test:", () {
    final AccomplishmentEntity accomplishment = AccomplishmentEntity(
        title: "test",
        issuer: "test",
        isActive: false,
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now(),
        description: "test",
        userId: "123");

    final AccomplishmentFormState initialState = AccomplishmentFormState(
      accomplishmentFormStatus: AccomplishmentFormStatus.initial,
      accomplishment: accomplishment,
      titleNameFieldInput: TextFieldInput.unvalidated(accomplishment.title),
      issuerFieldInput: TextFieldInput.unvalidated(accomplishment.issuer),
      descriptionFieldInput:
          TextFieldInput.unvalidated(accomplishment.description ?? ""),
      isActiveFieldInput:
          CheckboxFieldInput.unvalidated(accomplishment.isActive),
      startDateFieldInput:
          StartDateFieldInput.unvalidated(accomplishment.startDate),
      endDateFieldInput: EndDateFieldInput.unvalidated(
          isPresent: accomplishment.isActive, value: accomplishment.endDate),
    );

    blocTest<AccomplishmentFormCubit, AccomplishmentFormState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [AccomplishmentFormStatus.createSuccess, accomplishment] when create accomplishment succesful",
        // define mock behavior for this test case
        setUp: () {
          registerFallbackValue(
              CreateUserAccomplishmentRequest(accomplishment: accomplishment));
          when(() => mockUserRepository.createUserAccomplishment(any()))
              .thenAnswer((_) async => CreateUserAccomplishmentResponse(
                    accomplishment: accomplishment,
                  ));
        },
        // building the cubit including mock behaviors
        build: () => AccomplishmentFormCubit(
              userRepository: mockUserRepository,
            ),
        // what the cubit should do
        act: (cubit) =>
            cubit.handleSubmit(isEditMode: false, isApiCalled: true),
        seed: () => initialState,
        // after calling method what is the expected state
        expect: () => [
              initialState.copyWith(
                  accomplishmentFormStatus:
                      AccomplishmentFormStatus.createLoading,
                  accomplishment: accomplishment),
              initialState.copyWith(
                  accomplishmentFormStatus:
                      AccomplishmentFormStatus.createSuccess,
                  accomplishment: accomplishment),
            ],
        verify: (_) async {
          verify(() => mockUserRepository.createUserAccomplishment(any()))
              .called(1);
        });

    blocTest<AccomplishmentFormCubit, AccomplishmentFormState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [AccomplishmentFormStatus.createSuccess, accomplishment] when create accomplishment locally succesful",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => AccomplishmentFormCubit(
        userRepository: mockUserRepository,
      ),
      // what the cubit should do
      act: (cubit) => cubit.handleSubmit(isEditMode: false, isApiCalled: false),
      seed: () => initialState,
      // after calling method what is the expected state
      expect: () => [
        initialState.copyWith(
          accomplishment: accomplishment,
          accomplishmentFormStatus: AccomplishmentFormStatus.createSuccess,
        ),
      ],
    );

    blocTest<AccomplishmentFormCubit, AccomplishmentFormState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [AccomplishmentFormStatus.updateSuccess, accomplishment] when update accomplishment succesful",
        // define mock behavior for this test case
        setUp: () {
          registerFallbackValue(
              UpdateUserAccomplishmentRequest(accomplishment: accomplishment));
          when(() => mockUserRepository.updateUserAccomplishment(any()))
              .thenAnswer((_) async => UpdateUserAccomplishmentResponse(
                    accomplishment: accomplishment,
                  ));
        },
        // building the cubit including mock behaviors
        build: () => AccomplishmentFormCubit(
              userRepository: mockUserRepository,
            ),
        // what the cubit should do
        act: (cubit) => cubit.handleSubmit(isEditMode: true, isApiCalled: true),
        seed: () => initialState,
        // after calling method what is the expected state
        expect: () => [
              initialState.copyWith(
                  accomplishmentFormStatus:
                      AccomplishmentFormStatus.updateLoading,
                  accomplishment: accomplishment),
              initialState.copyWith(
                  accomplishmentFormStatus:
                      AccomplishmentFormStatus.updateSuccess,
                  accomplishment: accomplishment),
            ],
        verify: (_) async {
          verify(() => mockUserRepository.updateUserAccomplishment(any()))
              .called(1);
        });

    blocTest<AccomplishmentFormCubit, AccomplishmentFormState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [AccomplishmentFormStatus.updateSuccess, accomplishment] when update experience locally succesful",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => AccomplishmentFormCubit(
        userRepository: mockUserRepository,
      ),
      // what the cubit should do
      act: (cubit) => cubit.handleSubmit(isEditMode: true, isApiCalled: false),
      seed: () => initialState,
      // after calling method what is the expected state
      expect: () => [
        initialState.copyWith(
            accomplishmentFormStatus: AccomplishmentFormStatus.updateSuccess,
            accomplishment: accomplishment),
      ],
    );

    blocTest<AccomplishmentFormCubit, AccomplishmentFormState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [AccomplishmentFormStatus.deleteSuccess] when delete accomplishment succesful",
      // define mock behavior for this test case
      setUp: () {
        registerFallbackValue(
            DeleteUserAccomplishmentRequest(accomplishment: accomplishment));
        when(() => mockUserRepository.deleteUserAccomplishment(any()))
            .thenAnswer((_) async {});
      },
      // building the cubit including mock behaviors
      build: () => AccomplishmentFormCubit(
        userRepository: mockUserRepository,
      ),
      // what the cubit should do
      act: (cubit) => cubit.handleDelete(isApiCalled: true),
      seed: () => initialState,
      // after calling method what is the expected state
      expect: () => [
        initialState.copyWith(
          accomplishmentFormStatus: AccomplishmentFormStatus.deleteLoading,
        ),
        initialState.copyWith(
          accomplishmentFormStatus: AccomplishmentFormStatus.deleteSuccess,
        ),
      ],
    );

    blocTest<AccomplishmentFormCubit, AccomplishmentFormState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [AccomplishmentFormStatus.deleteSuccess] when delete accomplishment locally succesful",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => AccomplishmentFormCubit(
        userRepository: mockUserRepository,
      ),
      // what the cubit should do
      act: (cubit) => cubit.handleDelete(isApiCalled: false),
      seed: () => initialState,
      // after calling method what is the expected state
      expect: () => [
        initialState.copyWith(
          accomplishmentFormStatus: AccomplishmentFormStatus.deleteSuccess,
        ),
      ],
    );
  });
}
