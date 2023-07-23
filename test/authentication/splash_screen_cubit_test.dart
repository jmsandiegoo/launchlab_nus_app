import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/cubits/splash_screen_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSession extends Mock implements Session {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() async {
    mockAuthRepository = MockAuthRepository();
  });

  group("[Auth] SplashScreenCubit Test:", () {
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

    final Session session = MockSession();

    blocTest<SplashScreenCubit, SplashScreenState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [session, authProfile] when initialize auth session is successful",
        // define mock behavior for this test case
        setUp: () {
          // stub method
          when(() => mockAuthRepository.getCurrentAuthSession())
              .thenReturn(session);

          when(() => mockAuthRepository.getAuthUserProfile())
              .thenAnswer((invocation) async => user);
        },
        // building the cubit including mock behaviors
        build: () => SplashScreenCubit(mockAuthRepository),
        // what the cubit should do
        act: (cubit) => cubit.handleInitAuthSession(),
        // after calling method what is the expected state
        expect: () => [
              SplashScreenState(
                session: session,
                authUserProfile: user,
              ),
            ],
        verify: (_) async {
          verify(() => mockAuthRepository.getCurrentAuthSession()).called(1);
          verify(() => mockAuthRepository.getAuthUserProfile()).called(1);
        });
  });
}
