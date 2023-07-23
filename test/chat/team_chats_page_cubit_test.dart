import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/chat/chat_repository.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/chat/models/team_chat_entity.dart';
import 'package:launchlab/src/domain/team/responses/get_team_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/team_user_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/download_avatar_image_request.dart';
import 'package:launchlab/src/domain/user/models/requests/get_profile_info_request.dart';
import 'package:launchlab/src/domain/user/models/responses/get_profile_info_response.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/chat/cubits/team_chats_page_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockChatRepository extends Mock implements ChatRepository {}

class MockTeamRepository extends Mock implements TeamRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockRealtimeChannel extends Mock implements RealtimeChannel {}

class MockFile extends Mock implements File {}

void main() {
  late MockChatRepository mockChatRepository;
  late MockTeamRepository mockTeamRepository;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    mockTeamRepository = MockTeamRepository();
    mockUserRepository = MockUserRepository();
  });

  group("[Chat] TeamChatsPageCubit Test:", () {
    final TeamEntity team = TeamEntity(
        "teamId",
        "teamName",
        "description",
        2,
        3,
        DateTime.now().subtract(const Duration(days: 1)),
        DateTime.now(),
        "Low",
        "School",
        const [],
        "avatar.png",
        "avatarURL",
        true,
        true,
        const []);

    final List<TeamUserEntity> teamMembers = [
      const TeamUserEntity("1", "Owner", true, "123",
          UserEntity(isOnboarded: true, username: "user1")),
      const TeamUserEntity("2", "Member", false, "456",
          UserEntity(isOnboarded: true, username: "user2")),
    ];

    const UserEntity user = UserEntity(isOnboarded: true, username: "user1");

    final UserAvatarEntity userAvatar =
        UserAvatarEntity(userId: "userId", file: MockFile());

    const TeamChatEntity teamChat =
        TeamChatEntity(id: "id", isGroupChat: false, teamId: "teamId");

    const TeamChatsPageState initialState =
        TeamChatsPageState(teamChatsPageStatus: TeamChatsPageStatus.initial);

    blocTest<TeamChatsPageCubit, TeamChatsPageState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [team, teamUsers, teamChats, TeamChatsPageStatus.success] when submit successful",
      // define mock behavior for this test case
      setUp: () {
        when(() => mockTeamRepository.getTeamData(any())).thenAnswer((_) async {
          return GetTeamData(
            teamMembers,
            team,
            const [],
          );
        });

        when(() => mockTeamRepository.getTeamUsers(any()))
            .thenAnswer((invocation) async => teamMembers);

        registerFallbackValue(
            const DownloadAvatarImageRequest(userId: "userId"));

        when(() => mockUserRepository.fetchUserAvatar(any()))
            .thenAnswer((invocation) async => userAvatar);

        when(() => mockChatRepository.getTeamChatsByTeamId(
                teamId: any(named: "teamId")))
            .thenAnswer((invocation) async => [teamChat]);

        registerFallbackValue(const GetProfileInfoRequest(userId: "userId"));

        when(() => mockUserRepository.getUserBasicProfileInfo(any()))
            .thenAnswer((invocation) async =>
                const GetProfileInfoResponse(userProfile: user));

        when(() => mockTeamRepository.subscribeToTeamUsers(
                teamId: any(named: "teamId"),
                streamHandler: any(named: "streamHandler")))
            .thenAnswer((invocation) => MockRealtimeChannel());

        when(() => mockChatRepository.subscribeToTeamChatMessages(
                streamHandler: any(named: "streamHandler")))
            .thenAnswer((invocation) => MockRealtimeChannel());
      },
      // building the cubit including mock behaviors
      build: () => TeamChatsPageCubit(
        userRepository: mockUserRepository,
        chatRepository: mockChatRepository,
        teamRepository: mockTeamRepository,
      ),
      // what the cubit should do
      act: (cubit) => cubit.handleInitializePage("teamId", "userId"),
      // after calling method what is the expected state
      expect: () => [
        initialState.copyWith(
          teamUsers: teamMembers,
        ),
        initialState.copyWith(
            teamUsers: teamMembers,
            team: team,
            teamChatsPageStatus: TeamChatsPageStatus.success),
      ],
    );
  });
}
