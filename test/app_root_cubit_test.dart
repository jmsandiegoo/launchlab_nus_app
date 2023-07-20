import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockStream extends Mock implements Stream<AuthState> {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSession extends Mock implements Session {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() async {
    mockAuthRepository = MockAuthRepository();
  });

  group("AppRootCubit Test:", () {
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
    final Stream<AuthState> mockStream = MockStream();

    Stream<AuthState> streamYieldSignInFunc() async* {
      yield AuthState(AuthChangeEvent.signedIn, session);
    }

    /// need to mock the stream
    /// make the function call the mocked stream instead.

    blocTest<AppRootCubit, AppRootState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [isSignedIn, session, authUserProfile] when auth listener stream sends signed in event",
        // define mock behavior for this test case
        setUp: () {
          // stub method
          when(() => mockStream.listen(
                any(),
                onError: any(named: 'onError'),
                onDone: any(named: 'onDone'),
                cancelOnError: any(named: 'cancelOnError'),
              )).thenAnswer((Invocation invocation) {
            var onData = invocation.positionalArguments.single;
            var onError = invocation.namedArguments[#onError];
            var onDone = invocation.namedArguments[#onDone];
            var cancelOnError = invocation.namedArguments[#cancelOnError];

            return streamYieldSignInFunc().listen(onData,
                onError: onError, onDone: onDone, cancelOnError: cancelOnError);
          });

          when(() => mockAuthRepository.getCurrentAuthSession())
              .thenReturn(session);

          when(() => mockAuthRepository.getAuthUserProfile())
              .thenAnswer((invocation) async => user);

          when(() => mockAuthRepository.listenToAuth(any()))
              .thenAnswer((invocation) {
            mockStream.listen(invocation.positionalArguments[0]);
          });
        },
        // building the cubit including mock behaviors
        build: () => AppRootCubit(mockAuthRepository),
        // what the cubit should do
        act: (cubit) => cubit.handleAuthListener(),
        // wait for stream response
        wait: const Duration(milliseconds: 300),
        // after calling method what is the expected state
        expect: () => [
              AppRootState(
                isSignedIn: true,
                session: session,
                authUserProfile: user,
                appRootStateStatus: AppRootStateStatus.initial,
              ),
            ],
        verify: (_) async {
          verify(() => mockAuthRepository.listenToAuth(any())).called(1);
          verify(() => mockAuthRepository.getAuthUserProfile()).called(1);
          verify(() => mockAuthRepository.getCurrentAuthSession()).called(1);
        });

    Stream<AuthState> streamYieldSignOutFunc() async* {
      yield AuthState(AuthChangeEvent.signedOut, session);
    }

    blocTest<AppRootCubit, AppRootState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [isSignedIn, session, authUserProfile] when auth listener stream sends signed out event",
        // define mock behavior for this test case
        setUp: () {
          // stub method
          when(() => mockStream.listen(
                any(),
                onError: any(named: 'onError'),
                onDone: any(named: 'onDone'),
                cancelOnError: any(named: 'cancelOnError'),
              )).thenAnswer((Invocation invocation) {
            var onData = invocation.positionalArguments.single;
            var onError = invocation.namedArguments[#onError];
            var onDone = invocation.namedArguments[#onDone];
            var cancelOnError = invocation.namedArguments[#cancelOnError];

            return streamYieldSignOutFunc().listen(onData,
                onError: onError, onDone: onDone, cancelOnError: cancelOnError);
          });

          when(() => mockAuthRepository.getCurrentAuthSession())
              .thenReturn(session);

          when(() => mockAuthRepository.getAuthUserProfile())
              .thenAnswer((invocation) async => user);

          when(() => mockAuthRepository.listenToAuth(any()))
              .thenAnswer((invocation) {
            mockStream.listen(invocation.positionalArguments[0]);
          });
        },
        // building the cubit including mock behaviors
        build: () => AppRootCubit(mockAuthRepository),
        // what the cubit should do
        act: (cubit) => cubit.handleAuthListener(),
        // wait for stream response
        wait: const Duration(milliseconds: 300),
        // after calling method what is the expected state
        expect: () => [
              AppRootState(
                isSignedIn: false,
                session: session,
                authUserProfile: user,
                appRootStateStatus: AppRootStateStatus.initial,
              ),
            ],
        verify: (_) async {
          verify(() => mockAuthRepository.listenToAuth(any())).called(1);
          verify(() => mockAuthRepository.getAuthUserProfile()).called(1);
          verify(() => mockAuthRepository.getCurrentAuthSession()).called(1);
        });

    blocTest<AppRootCubit, AppRootState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [session, authProfile] when get auth profile is successful",
        // define mock behavior for this test case
        setUp: () {
          // stub method
          when(() => mockAuthRepository.getAuthUserProfile())
              .thenAnswer((invocation) async => user);
        },
        // building the cubit including mock behaviors
        build: () => AppRootCubit(mockAuthRepository),
        // what the cubit should do
        act: (cubit) => cubit.handleGetAuthUserProfile(),
        // after calling method what is the expected state
        expect: () => [
              const AppRootState(
                  isSignedIn: false,
                  appRootStateStatus: AppRootStateStatus.loading),
              AppRootState(
                  isSignedIn: false,
                  authUserProfile: user,
                  appRootStateStatus: AppRootStateStatus.success),
            ],
        verify: (_) async {
          verify(() => mockAuthRepository.getAuthUserProfile()).called(1);
        });

    blocTest<AppRootCubit, AppRootState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [session, authProfile] when get auth profile is successful",
        // define mock behavior for this test case
        setUp: () {
          // stub method
          when(() => mockAuthRepository.getAuthUserProfile())
              .thenAnswer((invocation) async => user);
        },
        // building the cubit including mock behaviors
        build: () => AppRootCubit(mockAuthRepository),
        // what the cubit should do
        act: (cubit) => cubit.handleGetAuthUserProfile(),
        // after calling method what is the expected state
        expect: () => [
              const AppRootState(
                  isSignedIn: false,
                  appRootStateStatus: AppRootStateStatus.loading),
              AppRootState(
                  isSignedIn: false,
                  authUserProfile: user,
                  appRootStateStatus: AppRootStateStatus.success),
            ],
        verify: (_) async {
          verify(() => mockAuthRepository.getAuthUserProfile()).called(1);
        });

    blocTest<AppRootCubit, AppRootState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [session, authProfile] when signout is successful",
        // define mock behavior for this test case
        setUp: () {
          // stub method
          when(() => mockAuthRepository.signOut())
              .thenAnswer((invocation) async {});
        },
        // building the cubit including mock behaviors
        build: () => AppRootCubit(mockAuthRepository),
        // what the cubit should do
        act: (cubit) => cubit.handleSignOut(),
        // after calling method what is the expected state
        expect: () => [],
        verify: (_) async {
          verify(() => mockAuthRepository.signOut()).called(1);
        });
  });
}
