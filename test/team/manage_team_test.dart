import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/domain/team/responses/get_manage_team_data.dart';
import 'package:launchlab/src/presentation/team/cubits/manage_team_cubit.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:mocktail/mocktail.dart';

import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';

class MockTeamRepository extends Mock implements TeamRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockTeamRepository mockTeamRepository;
  late ManageTeamCubit manageTeamCubit;

  group("Manage Team Cubit", () {
    setUp(() async {
      mockTeamRepository = MockTeamRepository();
      manageTeamCubit =
          ManageTeamCubit(mockTeamRepository, MockUserRepository());
    });

    final Failure failure = Failure.request();
    const String teamId = '2ebb33bb-0da1-450c-91c4-51f8befd57d1';
    GetManageTeamData getManageTeamData = const GetManageTeamData([], []);

    blocTest<ManageTeamCubit, ManageTeamState>(
      'Emits [applicantUserData, rolesData, ManageTeamStatus.success] when data is loaded.',
      setUp: () => when(() => mockTeamRepository.getManageTeamData(teamId))
          .thenAnswer((_) async => getManageTeamData),
      build: () => manageTeamCubit,
      act: (cubit) => cubit.getData(teamId),
      expect: () => <ManageTeamState>[
        ManageTeamState(
            applicantUserData: getManageTeamData.getAllApplicant(),
            rolesData: getManageTeamData.getAllRoles(),
            status: ManageTeamStatus.success),
      ],
      verify: (_) async {
        verify(() => mockTeamRepository.getManageTeamData(teamId)).called(1);
      },
    );

    blocTest<ManageTeamCubit, ManageTeamState>(
      'Emits [ManageTeamStatus.error] when failure is caught.',
      setUp: () => when(() => mockTeamRepository.getManageTeamData(teamId))
          .thenThrow(failure),
      build: () => manageTeamCubit,
      act: (cubit) => cubit.getData(teamId),
      expect: () => <ManageTeamState>[
        ManageTeamState(status: ManageTeamStatus.error, error: failure),
      ],
      verify: (_) async {
        verify(() => mockTeamRepository.getManageTeamData(teamId)).called(1);
      },
    );

    blocTest<ManageTeamCubit, ManageTeamState>(
      'Emits [ManageTeamStatus.loading] when calling loading()'
      'loading test.',
      build: () => manageTeamCubit,
      act: (cubit) => cubit.loading(),
      expect: () => [const ManageTeamState(status: ManageTeamStatus.loading)],
    );
  });
}
