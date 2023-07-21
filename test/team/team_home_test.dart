import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/domain/team/responses/get_team_home_data.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:mocktail/mocktail.dart';

import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/presentation/team/cubits/team_home_cubit.dart';

class MockTeamRepository extends Mock implements TeamRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockUserEntity extends Mock implements UserEntity {}

void main() {
  late MockTeamRepository mockTeamRepository;
  late MockUserRepository mockUserRepository;
  late TeamHomeCubit teamHomeCubit;

  group("Team Home Cubit", () {
    setUp(() async {
      mockTeamRepository = MockTeamRepository();
      mockUserRepository = MockUserRepository();
      teamHomeCubit = TeamHomeCubit(
          MockAuthRepository(), mockTeamRepository, mockUserRepository);
    });

    blocTest<TeamHomeCubit, TeamHomeState>(
      'Emits [isLeading: false] when calling setIsLeadingState'
      'isLeading Test.',
      build: () => teamHomeCubit,
      act: (cubit) => cubit.setIsLeadingState(false),
      expect: () => [const TeamHomeState(isLeading: false)],
    );

    blocTest<TeamHomeCubit, TeamHomeState>(
      'Emits [TeamHomeStatus.loading] when calling loading()'
      'loading test.',
      build: () => teamHomeCubit,
      act: (cubit) => cubit.loading(),
      expect: () => [const TeamHomeState(status: TeamHomeStatus.loading)],
    );

    final Failure failure = Failure.request();

/*
    final MockUserEntity user = MockUserEntity();

    const GetTeamHomeData teamHomeData = GetTeamHomeData(
        [],
        [],
        UserEntity(
            id: 'c20dc7ab-5fac-4e66-bde9-dd5b74d35d10',
            isOnboarded: true,
            username: 'anya',
            firstName: 'Anya',
            lastName: 'Forger',
            title: 'Student',
            about: 'God of CS, 5.0 CAP every sem.',
            degreeProgrammeId: '078c4fb4-6c44-476b-9332-645c586799a9'));


    blocTest<TeamHomeCubit, TeamHomeState>(
      'emits [TeamHomeStatus.success] when data is loaded successfully.',
      build: () => teamHomeCubit,
      setUp: () {
        when(() => mockTeamRepository.getTeamHomeData())
            .thenAnswer((_) async => teamHomeData);
      },
      act: (cubit) => cubit.getData(),
      expect: () =>
          const <TeamHomeState>[TeamHomeState(status: TeamHomeStatus.success)],
      verify: (_) async {
        verify(() => mockTeamRepository.getTeamHomeData()).called(1);
      },
    );
*/
    blocTest<TeamHomeCubit, TeamHomeState>(
      'Emits [TeamHomeStatus.error] when failure is caught.',
      setUp: () =>
          when(() => mockTeamRepository.getTeamHomeData()).thenThrow(failure),
      build: () => teamHomeCubit,
      act: (cubit) => cubit.getData(),
      expect: () => <TeamHomeState>[
        TeamHomeState(status: TeamHomeStatus.error, error: failure),
      ],
      verify: (_) async {
        verify(() => mockTeamRepository.getTeamHomeData()).called(1);
      },
    );
  });
}
