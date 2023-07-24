import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/domain/team/responses/get_team_home_data.dart';
import 'package:launchlab/src/domain/user/models/requests/download_avatar_image_request.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
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

class MockFile extends Mock implements File {
  @override
  String path = '';
}

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

    final Failure failure = Failure.request();

    final UserAvatarEntity userAvatar =
        UserAvatarEntity(userId: "userId", file: MockFile());

    GetTeamHomeData teamHomeData = GetTeamHomeData(
        const [],
        const [],
        UserEntity(
            isOnboarded: true,
            username: "user1",
            id: '',
            userAvatar: userAvatar));

    blocTest<TeamHomeCubit, TeamHomeState>(
      'emits [memberTeamData, ownerTeamData, userData, TeamHomeStatus.success] when data is loaded successfully.',
      build: () => teamHomeCubit,
      setUp: () {
        when(() => mockTeamRepository.getTeamHomeData())
            .thenAnswer((_) async => teamHomeData);

        registerFallbackValue(
            const DownloadAvatarImageRequest(userId: "userId"));

        when(() => mockUserRepository.fetchUserAvatar(any()))
            .thenAnswer((invocation) async => userAvatar);
      },
      act: (cubit) => cubit.getData(),
      expect: () => <TeamHomeState>[
        TeamHomeState(
            memberTeamData: teamHomeData.memberTeams,
            ownerTeamData: teamHomeData.ownerTeams,
            userData: teamHomeData.user,
            status: TeamHomeStatus.success)
      ],
      verify: (_) async {
        verify(() => mockTeamRepository.getTeamHomeData()).called(1);
      },
    );

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
  });
}
