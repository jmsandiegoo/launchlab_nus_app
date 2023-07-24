import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/search/search_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/search/external_team_entity.dart';
import 'package:launchlab/src/domain/search/responses/get_external_team.dart';
import 'package:launchlab/src/domain/team/team_user_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/download_avatar_image_request.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/search/cubits/external_team_cubit.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockFile extends Mock implements File {}

void main() {
  late MockSearchRepository mockSearchRepository;
  late ExternalTeamCubit externalTeamCubit;
  late MockUserRepository mockUserRepository;

  group("External Team Cubit", () {
    setUp(() async {
      mockSearchRepository = MockSearchRepository();
      mockUserRepository = MockUserRepository();
      externalTeamCubit =
          ExternalTeamCubit(mockSearchRepository, mockUserRepository);
    });

    final Failure failure = Failure.request();

    UserEntity user = const UserEntity(
        id: '',
        isOnboarded: true,
        username: '',
        firstName: '',
        lastName: '',
        title: '',
        about: '',
        degreeProgrammeId: '');

    GetExternalTeam searchUserResult = GetExternalTeam(
        ExternalTeamEntity('', '', '', 1, 1, DateTime.now(), DateTime.now(), '',
            '', const [], '', '', const [], const []),
        TeamUserEntity('', "Owner", true, '', user),
        const []);
    final UserAvatarEntity userAvatar =
        UserAvatarEntity(userId: "userId", file: MockFile());

    blocTest<ExternalTeamCubit, ExternalTeamState>(
      'emits [teamData, ExternalTeamStatus.success] when data is successfully loaded.',
      setUp: () {
        when(() => mockSearchRepository.getExternalTeamData(''))
            .thenAnswer((_) async => searchUserResult);

        registerFallbackValue(
            const DownloadAvatarImageRequest(userId: "userId"));

        when(() => mockUserRepository.fetchUserAvatar(any()))
            .thenAnswer((invocation) async => userAvatar);
      },
      build: () => externalTeamCubit,
      act: (cubit) => cubit.getData(''),
      expect: () => <ExternalTeamState>[
        ExternalTeamState(
            teamData: searchUserResult.teamData,
            status: ExternalTeamStatus.success),
      ],
      verify: (_) async {
        verify(() => mockSearchRepository.getExternalTeamData('')).called(1);
      },
    );

    blocTest<ExternalTeamCubit, ExternalTeamState>(
      'emits [ExternalTeamStatus.loading, ExternalTeamStatus.error] when failure is caught.',
      setUp: () => when(() => mockSearchRepository.getExternalTeamData(''))
          .thenThrow(failure),
      build: () => externalTeamCubit,
      act: (cubit) => cubit.getData(''),
      expect: () => <ExternalTeamState>[
        ExternalTeamState(status: ExternalTeamStatus.error, error: failure),
      ],
      verify: (_) async {
        verify(() => mockSearchRepository.getExternalTeamData('')).called(1);
      },
    );
  });
}
