import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/domain/team/responses/get_team_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/presentation/team/cubits/team_cubit.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:mocktail/mocktail.dart';

import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';

class MockTeamRepository extends Mock implements TeamRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockTeamRepository mockTeamRepository;
  late TeamCubit teamCubit;

  group("Team Cubit", () {
    setUp(() async {
      mockTeamRepository = MockTeamRepository();
      teamCubit = TeamCubit(mockTeamRepository, MockUserRepository());
    });

    final Failure failure = Failure.request();
    const String teamId = '';
    TeamEntity teamData = TeamEntity('', '', '', 1, 1, DateTime.now(), null, '',
        '', const [], null, '', true, true, const []);
    GetTeamData getTeamData = GetTeamData(const [], teamData, const []);

    blocTest<TeamCubit, TeamState>(
      'emits [teamData, TeamStatus.success] when data is loaded successfully.',
      build: () => teamCubit,
      setUp: () => when(() => mockTeamRepository.getTeamData(teamId))
          .thenAnswer((_) async => getTeamData),
      act: (cubit) => cubit.getData(teamId),
      expect: () => <TeamState>[
        TeamState(teamData: teamData, status: TeamStatus.success)
      ],
      verify: (_) async {
        verify(() => mockTeamRepository.getTeamData(teamId)).called(1);
      },
    );

    blocTest<TeamCubit, TeamState>(
      'Emits [TeamStatus.error] when failure is caught.',
      setUp: () =>
          when(() => mockTeamRepository.getTeamData(teamId)).thenThrow(failure),
      build: () => teamCubit,
      act: (cubit) => cubit.getData(teamId),
      expect: () => <TeamState>[
        TeamState(status: TeamStatus.error, error: failure),
      ],
      verify: (_) async {
        verify(() => mockTeamRepository.getTeamData(teamId)).called(1);
      },
    );

    blocTest<TeamCubit, TeamState>(
      'Emits [teamData, TeamStatus.loading] when calling loading()',
      build: () => teamCubit,
      act: (cubit) => cubit.loading(),
      expect: () => [const TeamState(status: TeamStatus.loading)],
    );
  });
}
