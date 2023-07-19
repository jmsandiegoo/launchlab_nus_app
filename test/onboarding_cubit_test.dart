import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/requests/onboard_user_request.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockCommonRepository extends Mock implements CommonRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late CommonRepository mockCommonRepository;

  setUp(() async {
    mockUserRepository = MockUserRepository();
    mockCommonRepository = MockCommonRepository();
  });

  group("Onboarding User", () {
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

    blocTest<OnboardingCubit, OnboardingState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "Onboard successfully",
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
  });
}
