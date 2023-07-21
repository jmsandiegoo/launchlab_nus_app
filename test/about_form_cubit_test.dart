import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_request.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/user/cubits/about_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/username_field.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:mocktail/mocktail.dart';

class MockUserNameFieldInput extends Mock implements UsernameFieldInput {}

class MockUserRepository extends Mock implements UserRepository {}

class MockFile extends Mock implements File {}

void main() {
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
  });

  group("[Profile] AboutFormCubit Test:", () {
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
      userDegreeProgramme: const DegreeProgrammeEntity(
          id: "123",
          type: "Undegraduate",
          name: "Bachelor in Computer Science"),
    );

    final AboutFormState initialState = AboutFormState(
      aboutInput: TextFieldInput.unvalidated(
        user.about ?? '',
      ),
      aboutFormStatus: AboutFormStatus.initial,
      userProfile: user,
    );

    blocTest<AboutFormCubit, AboutFormState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [introFormStatus.success] when submit successful",
        // define mock behavior for this test case
        setUp: () {
          registerFallbackValue(UpdateUserRequest(userProfile: user));
          when(() => mockUserRepository.updateUser(any()))
              .thenAnswer((_) async {});
        },
        // building the cubit including mock behaviors
        build: () => AboutFormCubit(
              userRepository: mockUserRepository,
              userProfile: user,
            ),
        // what the cubit should do
        act: (cubit) => cubit.handleSubmit(),
        // after calling method what is the expected state
        expect: () => [
              initialState.copyWith(
                aboutFormStatus: AboutFormStatus.loading,
              ),
              initialState.copyWith(
                aboutFormStatus: AboutFormStatus.success,
              ),
            ],
        verify: (_) async {
          verify(() => mockUserRepository.updateUser(any())).called(1);
        });

    final Failure failure =
        Failure.request(message: "Failed to update user about me");

    blocTest<AboutFormCubit, AboutFormState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [introFormStatus.success] when submit fails",
        // define mock behavior for this test case
        setUp: () {
          registerFallbackValue(UpdateUserRequest(userProfile: user));
          when(() => mockUserRepository.updateUser(any())).thenThrow(failure);
        },
        // building the cubit including mock behaviors
        build: () => AboutFormCubit(
              userRepository: mockUserRepository,
              userProfile: user,
            ),
        // what the cubit should do
        act: (cubit) => cubit.handleSubmit(),
        // after calling method what is the expected state
        expect: () => [
              initialState.copyWith(
                aboutFormStatus: AboutFormStatus.loading,
              ),
              initialState.copyWith(
                aboutFormStatus: AboutFormStatus.error,
                error: failure,
              ),
            ],
        verify: (_) async {
          verify(() => mockUserRepository.updateUser(any())).called(1);
        });

    blocTest<AboutFormCubit, AboutFormState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [aboutInput] when form inputs are invalid",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => AboutFormCubit(
        userRepository: mockUserRepository,
        userProfile: user,
      ),
      seed: () => initialState.copyWith(
        aboutInput: const TextFieldInput.unvalidated(),
      ),
      // what the cubit should do
      act: (cubit) => cubit.handleSubmit(),
      // after calling method what is the expected state
      expect: () => [
        initialState.copyWith(
          aboutInput: const TextFieldInput.validated(),
        ),
      ],
    );
  });
}
