import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/check_if_username_exists_request.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_request.dart';
import 'package:launchlab/src/domain/user/models/requests/upload_user_avatar_request.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/picture_upload_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/user/cubits/intro_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/degree_programme_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/username_field.dart';
import 'package:launchlab/src/utils/extensions.dart';
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

  group("[Profile] IntroFormCubit Test:", () {
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

    final IntroFormState initialState = IntroFormState(
        pictureUploadPickerInput:
            PictureUploadPickerInput.unvalidated(user.userAvatar?.file),
        usernameInput: UsernameFieldInput.unvalidated(user.username),
        firstNameInput: TextFieldInput.unvalidated(user.firstName ?? ''),
        lastNameInput: TextFieldInput.unvalidated(user.lastName ?? ''),
        titleInput: TextFieldInput.unvalidated(user.title ?? ''),
        degreeProgrammeInput:
            DegreeProgrammeFieldInput.unvalidated(user.userDegreeProgramme),
        degreeProgrammeOptions: const [],
        introFormStatus: IntroFormStatus.initial,
        userProfile: user);

    blocTest<IntroFormCubit, IntroFormState>(
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
        build: () => IntroFormCubit(
            userProfile: user,
            userRepository: mockUserRepository,
            userAvatar: user.userAvatar,
            userDegreeProgramme: user.userDegreeProgramme!),
        // what the cubit should do
        act: (cubit) => cubit.handleGetDegreeProgrammes("test"),
        // after calling method what is the expected state
        expect: () => [
              initialState.copyWith(
                degreeProgrammeOptions: degreeProgrammes,
              ),
            ],
        verify: (_) async {
          verify(() => mockUserRepository.getDegreeProgrammes(any())).called(1);
        });

    final MockFile mockFile = MockFile();

    final UserEntity updateUser = UserEntity(
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
      userAvatar: UserAvatarEntity(userId: "123", file: mockFile),
    );

    final IntroFormState updateInitialState = initialState.copyWith(
      pictureUploadPickerInput: PictureUploadPickerInput.unvalidated(mockFile),
      userProfile: updateUser,
    );

    blocTest<IntroFormCubit, IntroFormState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [introFormStatus.success] when submit successful",
        // define mock behavior for this test case
        setUp: () {
          when(() => mockFile.name).thenAnswer((invocation) => "name");

          when(() => mockFile.ext).thenAnswer((invocation) => ".pdf");

          registerFallbackValue(UploadUserAvatarRequest(
              userAvatar: UserAvatarEntity(userId: "123", file: mockFile)));

          when(() => mockUserRepository.uploadUserAvatar(any()))
              .thenAnswer((_) async {});

          registerFallbackValue(UpdateUserRequest(userProfile: updateUser));

          when(() => mockUserRepository.updateUser(any()))
              .thenAnswer((_) async {});

          registerFallbackValue(const CheckIfUsernameExistsRequest(
            username: "test",
          ));

          when(() => mockUserRepository.checkIfUsernameExists(any()))
              .thenAnswer((invocation) async => false);
        },
        // building the cubit including mock behaviors
        build: () => IntroFormCubit(
            userProfile: updateUser,
            userRepository: mockUserRepository,
            userAvatar: updateUser.userAvatar,
            userDegreeProgramme: updateUser.userDegreeProgramme!),
        // what the cubit should do
        act: (cubit) => cubit.handleSubmit(),
        // after calling method what is the expected state
        expect: () => [
              updateInitialState.copyWith(
                introFormStatus: IntroFormStatus.loading,
              ),
              updateInitialState.copyWith(
                introFormStatus: IntroFormStatus.success,
              ),
            ],
        verify: (_) async {
          verify(() => mockUserRepository.uploadUserAvatar(any())).called(1);
          verify(() => mockUserRepository.updateUser(any())).called(1);
        });

    final Failure failure = Failure.request(message: "Failed to update user");

    blocTest<IntroFormCubit, IntroFormState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [introFormStatus.error, error] when submit fails",
        // define mock behavior for this test case
        setUp: () {
          when(() => mockFile.name).thenAnswer((invocation) => "name");

          when(() => mockFile.ext).thenAnswer((invocation) => ".pdf");

          registerFallbackValue(UploadUserAvatarRequest(
              userAvatar: UserAvatarEntity(userId: "123", file: mockFile)));

          when(() => mockUserRepository.uploadUserAvatar(any()))
              .thenAnswer((_) async {});

          registerFallbackValue(UpdateUserRequest(userProfile: updateUser));

          when(() => mockUserRepository.updateUser(any())).thenThrow(failure);

          registerFallbackValue(const CheckIfUsernameExistsRequest(
            username: "test",
          ));

          when(() => mockUserRepository.checkIfUsernameExists(any()))
              .thenAnswer((invocation) async => false);
        },
        // building the cubit including mock behaviors
        build: () => IntroFormCubit(
            userProfile: updateUser,
            userRepository: mockUserRepository,
            userAvatar: updateUser.userAvatar,
            userDegreeProgramme: updateUser.userDegreeProgramme!),
        // what the cubit should do
        act: (cubit) => cubit.handleSubmit(),
        // after calling method what is the expected state
        expect: () => [
              updateInitialState.copyWith(
                introFormStatus: IntroFormStatus.loading,
              ),
              updateInitialState.copyWith(
                  introFormStatus: IntroFormStatus.error, error: failure)
            ],
        verify: (_) async {
          verify(() => mockUserRepository.uploadUserAvatar(any())).called(1);
          verify(() => mockUserRepository.updateUser(any())).called(1);
        });

    blocTest<IntroFormCubit, IntroFormState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [...validatedInputs] when form inputs are invalid",
      // define mock behavior for this test case
      setUp: () {
        when(() => mockFile.name).thenAnswer((invocation) => "name");

        when(() => mockFile.ext).thenAnswer((invocation) => ".pdf");

        registerFallbackValue(UploadUserAvatarRequest(
            userAvatar: UserAvatarEntity(userId: "123", file: mockFile)));

        when(() => mockUserRepository.uploadUserAvatar(any()))
            .thenAnswer((_) async {});

        registerFallbackValue(UpdateUserRequest(userProfile: updateUser));

        when(() => mockUserRepository.updateUser(any()))
            .thenAnswer((_) async {});

        registerFallbackValue(const CheckIfUsernameExistsRequest(
          username: "test",
        ));

        when(() => mockUserRepository.checkIfUsernameExists(any()))
            .thenAnswer((invocation) async => true);
      },
      // building the cubit including mock behaviors
      build: () => IntroFormCubit(
          userProfile: updateUser,
          userRepository: mockUserRepository,
          userAvatar: updateUser.userAvatar,
          userDegreeProgramme: updateUser.userDegreeProgramme!),
      // what the cubit should do
      act: (cubit) => cubit.handleSubmit(),
      // after calling method what is the expected state
      expect: () => [
        updateInitialState.copyWith(
          introFormStatus: IntroFormStatus.loading,
        ),
        updateInitialState.copyWith(
          pictureUploadPickerInput:
              PictureUploadPickerInput.validated(mockFile),
          firstNameInput: TextFieldInput.validated(user.firstName!),
          lastNameInput: TextFieldInput.validated(user.lastName!),
          titleInput: TextFieldInput.validated(user.title!),
          degreeProgrammeInput:
              DegreeProgrammeFieldInput.validated(user.userDegreeProgramme!),
          usernameAsyncError: UsernameFieldError.exist,
          isForceUsernameErrorNull: true,
          introFormStatus: IntroFormStatus.idle,
        ),
      ],
    );
  });
}
