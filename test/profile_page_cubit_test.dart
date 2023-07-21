import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/requests/delete_user_avatar_resume_request.dart';
import 'package:launchlab/src/domain/user/models/requests/get_profile_info_request.dart';
import 'package:launchlab/src/domain/user/models/requests/upload_user_resume_request.dart';
import 'package:launchlab/src/domain/user/models/responses/get_profile_info_response.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/domain/user/models/user_resume_entity.dart';
import 'package:launchlab/src/presentation/user/cubits/profile_page_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_resume_field.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockFile extends Mock implements File {}

void main() {
  late MockUserRepository mockUserRepository;

  setUp(() async {
    mockUserRepository = MockUserRepository();
  });

  group("[Profile] ProfilePageCubit Test:", () {
    final UserEntity user = UserEntity(
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

    final mockGetProfileResponse = GetProfileInfoResponse(userProfile: user);

    blocTest<ProfilePageCubit, ProfilePageState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [userProfile, profilePageStatus.success, userResumeInput] get profile information is successful",
        // define mock behavior for this test case
        setUp: () {
          // stub method
          registerFallbackValue(const GetProfileInfoRequest(userId: "123"));
          when(() => mockUserRepository.getProfileInfo(any()))
              .thenAnswer((invocation) async => mockGetProfileResponse);
        },
        // building the cubit including mock behaviors
        build: () => ProfilePageCubit(mockUserRepository),
        // what the cubit should do
        act: (cubit) => cubit.handleGetProfileInfo("123"),
        // after calling method what is the expected state
        expect: () => [
              const ProfilePageState(
                userProfile: null,
                profilePageStatus: ProfilePageStatus.loading,
              ),
              ProfilePageState(
                  userProfile: user,
                  profilePageStatus: ProfilePageStatus.success,
                  userResumeInput: const UserResumeFieldInput.unvalidated()),
            ],
        verify: (_) async {
          verify(() => mockUserRepository.getProfileInfo(any())).called(1);
        });

    final failure = Failure.request(message: "Failed to get profile info");

    blocTest<ProfilePageCubit, ProfilePageState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [profilePageStatus.error, error] get profile information is fails",
        // define mock behavior for this test case
        setUp: () {
          // stub method
          registerFallbackValue(const GetProfileInfoRequest(userId: "123"));
          when(() => mockUserRepository.getProfileInfo(any()))
              .thenThrow(failure);
        },
        // building the cubit including mock behaviors
        build: () => ProfilePageCubit(mockUserRepository),
        // what the cubit should do
        act: (cubit) => cubit.handleGetProfileInfo("123"),
        // after calling method what is the expected state
        expect: () => [
              const ProfilePageState(
                userProfile: null,
                profilePageStatus: ProfilePageStatus.loading,
              ),
              ProfilePageState(
                profilePageStatus: ProfilePageStatus.error,
                error: failure,
              ),
            ],
        verify: (_) async {
          verify(() => mockUserRepository.getProfileInfo(any())).called(1);
        });

    final mockFile = MockFile();

    blocTest<ProfilePageCubit, ProfilePageState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [newUserResumeInputState] when resume upload successful",
      // define mock behavior for this test case
      setUp: () {
        registerFallbackValue(UploadUserResumeRequest(
            userResume: UserResumeEntity(userId: "123", file: mockFile)));
        when(() => mockUserRepository.uploadUserResume(any()))
            .thenAnswer((_) async {});
      },
      // building the cubit including mock behaviors
      build: () => ProfilePageCubit(mockUserRepository),
      seed: () => ProfilePageState(
        userProfile: user,
        profilePageStatus: ProfilePageStatus.initial,
        userResumeInput: const UserResumeFieldInput.unvalidated(),
      ),
      // what the cubit should do
      act: (cubit) => cubit.onUserResumeChanged(mockFile),
      // after calling method what is the expected state
      expect: () => [
        ProfilePageState(
          userProfile: user,
          userResumeInput: UserResumeFieldInput.validated(mockFile),
          profilePageStatus: ProfilePageStatus.uploadLoading,
        ),
        ProfilePageState(
            userProfile: user,
            userResumeInput: UserResumeFieldInput.validated(mockFile),
            profilePageStatus: ProfilePageStatus.success),
      ],
      verify: (_) async {
        verify(() => mockUserRepository.uploadUserResume(any())).called(1);
      },
    );

    blocTest<ProfilePageCubit, ProfilePageState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [newUserResumeInputState] when resume delete successful",
      // define mock behavior for this test case
      setUp: () {
        registerFallbackValue(
            const DeleteUserAvatarResumeRequest(userId: "123"));
        when(() => mockUserRepository.deleteUserResume(any()))
            .thenAnswer((_) async {});
      },
      // building the cubit including mock behaviors
      build: () => ProfilePageCubit(mockUserRepository),
      seed: () => ProfilePageState(
        userProfile: user,
        profilePageStatus: ProfilePageStatus.initial,
        userResumeInput: const UserResumeFieldInput.unvalidated(),
      ),
      // what the cubit should do
      act: (cubit) => cubit.onUserResumeChanged(null),
      // after calling method what is the expected state
      expect: () => [
        ProfilePageState(
          userProfile: user,
          userResumeInput: const UserResumeFieldInput.unvalidated(null),
          profilePageStatus: ProfilePageStatus.uploadLoading,
        ),
        ProfilePageState(
            userProfile: user,
            userResumeInput: const UserResumeFieldInput.validated(null),
            profilePageStatus: ProfilePageStatus.success),
      ],
      verify: (_) async {
        verify(() => mockUserRepository.deleteUserResume(any())).called(1);
      },
    );
  });
}
