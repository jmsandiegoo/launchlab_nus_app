import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/chat/chat_repository.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/chat/models/chat_message_entity.dart';
import 'package:launchlab/src/domain/chat/models/chat_user_entity.dart';
import 'package:launchlab/src/domain/chat/models/team_chat_entity.dart';
import 'package:launchlab/src/domain/team/responses/get_team_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/team_user_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/download_avatar_image_request.dart';
import 'package:launchlab/src/domain/user/models/requests/get_profile_info_request.dart';
import 'package:launchlab/src/domain/user/models/responses/get_profile_info_response.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/utils/failure.dart';

class TeamChatsPageState extends Equatable {
  const TeamChatsPageState({
    this.searchInput = const TextFieldInput.unvalidated(),
    this.userProfilesCache = const {},
    this.team,
    required this.teamChatsPageStatus,
    this.teamChats = const [],
    this.teamUsers = const [],
    this.error,
  });

  final TeamEntity? team;
  final List<TeamChatEntity> teamChats;
  final List<TeamUserEntity> teamUsers;
  final Map<String, UserEntity> userProfilesCache;
  final TextFieldInput searchInput;
  final TeamChatsPageStatus teamChatsPageStatus;
  final Failure? error;

  TeamChatsPageState copyWith({
    TeamEntity? team,
    List<TeamChatEntity>? teamChats,
    List<TeamUserEntity>? teamUsers,
    Map<String, UserEntity>? userProfilesCache,
    TextFieldInput? searchInput,
    TeamChatsPageStatus? teamChatsPageStatus,
    Failure? error,
  }) {
    return TeamChatsPageState(
      team: team ?? this.team,
      teamChats: teamChats ?? this.teamChats,
      teamUsers: teamUsers ?? this.teamUsers,
      userProfilesCache: userProfilesCache ?? this.userProfilesCache,
      searchInput: searchInput ?? this.searchInput,
      teamChatsPageStatus: teamChatsPageStatus ?? this.teamChatsPageStatus,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        team,
        teamChats,
        teamUsers,
        userProfilesCache,
        searchInput,
        teamChatsPageStatus,
        error,
      ];
}

enum TeamChatsPageStatus {
  initial,
  success,
  teamChatsLoading,
  error,
}

class TeamChatsPageCubit extends Cubit<TeamChatsPageState> {
  TeamChatsPageCubit({
    required this.teamRepository,
    required this.chatRepository,
    required this.userRepository,
  }) : super(const TeamChatsPageState(
          teamChatsPageStatus: TeamChatsPageStatus.initial,
        ));

  final ChatRepository chatRepository;
  final TeamRepository teamRepository;
  final UserRepository userRepository;

  Future<void> handleInitializePage(String teamId, String currUserId) async {
    try {
      // fetch the team data
      final GetTeamData response = await teamRepository.getTeamData(teamId);
      TeamEntity team = response.team;

      // fetch team users
      final List<TeamUserEntity> teamUsers = await _handleGetTeamUsers(teamId);

      // fetch team chats
      final List<TeamChatEntity> teamChats =
          await _handleGetTeamChats(teamId, currUserId);

      // setup subsciption channels
      handleSubscribeToTeamUsers(team.id, currUserId);
      handleSubscribeToTeamChatMessages();

      emit(state.copyWith(
        team: team,
        teamUsers: teamUsers,
        teamChats: teamChats,
        teamChatsPageStatus: TeamChatsPageStatus.success,
      ));
    } on Exception catch (error) {}
  }

  void handleSubscribeToTeamUsers(String teamId, String currUserId) {
    teamRepository.subscribeToTeamUsers(
        teamId: teamId,
        streamHandler: (payload) async {
          await _handleGetTeamUsers(teamId);
          await _handleGetTeamChats(teamId, currUserId);
        });
  }

  void handleSubscribeToTeamChatMessages() {
    chatRepository.subscribeToTeamChatMessages(
      streamHandler: (payload) async {
        Map<String, UserEntity> userProfilesCache =
            Map.of(state.userProfilesCache);
        // check if inserted record is within the following chats
        ChatMessageEntity message = ChatMessageEntity.fromJson(payload["new"]);

        // load user details tied with the message
        if (state.userProfilesCache[message.userId] == null) {
          final GetProfileInfoResponse res =
              await userRepository.getUserBasicProfileInfo(
                  GetProfileInfoRequest(userId: message.userId));

          userProfilesCache[message.userId] = res.userProfile;

          message = message.setUser(user: res.userProfile);
          emit(state.copyWith(userProfilesCache: userProfilesCache));
        } else {
          message =
              message.setUser(user: state.userProfilesCache[message.userId]);
        }

        List<TeamChatEntity> teamChats = [...state.teamChats];

        for (int i = 0; i < teamChats.length; i++) {
          final TeamChatEntity teamChat = state.teamChats[i];
          if (teamChat.id == message.chatId) {
            teamChats[i] = teamChat.appendMessages(messages: [message]);
            teamChats.sort();
            emit(state.copyWith(teamChats: teamChats));
            break;
          }
        }
      },
    );
  }

  Future<List<TeamUserEntity>> _handleGetTeamUsers(String teamId) async {
    Map<String, UserEntity> userProfilesCache = Map.of(state.userProfilesCache);

    List<TeamUserEntity> teamMembers =
        await teamRepository.getTeamUsers(teamId);

    for (int i = 0; i < teamMembers.length; i++) {
      final TeamUserEntity member = teamMembers[i];

      if (userProfilesCache[member.userId] != null) {
        // use cache
        teamMembers[i] =
            member.copyWith(user: userProfilesCache[member.userId]);
      } else {
        // fetch and add to cache
        UserAvatarEntity? avatar = await userRepository.fetchUserAvatar(
            DownloadAvatarImageRequest(
                userId: member.userId, isSignedUrlEnabled: true));

        teamMembers[i] =
            member.copyWith(user: member.user.copyWith(userAvatar: avatar));

        userProfilesCache[teamMembers[i].userId] = teamMembers[i].user;
      }
    }

    emit(state.copyWith(
      teamUsers: teamMembers,
    ));

    return teamMembers;
  }

  Future<List<TeamChatEntity>> _handleGetTeamChats(
    String teamId,
    String currUserId,
  ) async {
    Map<String, UserEntity> userProfilesCache = Map.of(state.userProfilesCache);

    TeamEntity team;
    if (state.team != null) {
      team = state.team!;
    } else {
      final GetTeamData response = await teamRepository.getTeamData(teamId);
      team = response.team;
    }

    // fetch teamChats
    List<TeamChatEntity> teamChats =
        await chatRepository.getTeamChatsByTeamId(teamId: teamId);

    for (int i = teamChats.length - 1; i >= 0; i--) {
      // filter the chats containing members and currUser
      if (!teamChats[i].checkIfChatForUser(currUserId, state.teamUsers)) {
        teamChats.removeAt(i);
        continue;
      }

      // set the relational object(s) team & chatUsers
      teamChats[i] = teamChats[i].setTeam(team: team);

      List<ChatUserEntity> chatUsers = [];

      for (int j = 0; j < teamChats[i].chatUsers.length; j++) {
        ChatUserEntity chatUser = teamChats[i].chatUsers[j];
        if (userProfilesCache[chatUser.userId] != null) {
          chatUsers
              .add(chatUser.setUser(user: userProfilesCache[chatUser.userId]));
        } else {
          final GetProfileInfoResponse res =
              await userRepository.getUserBasicProfileInfo(
                  GetProfileInfoRequest(userId: chatUser.userId));

          chatUsers.add(chatUser.setUser(user: res.userProfile));

          userProfilesCache[chatUser.userId] = res.userProfile;
        }
      }

      teamChats[i] = teamChats[i].setChatUsers(chatUsers: chatUsers);
    }

    teamChats.sort();

    emit(state.copyWith(
      teamChats: teamChats,
    ));

    return teamChats;
  }

  void onSearchChanged(String val) {
    final prevState = state;
    final prevSearchInputState = prevState.searchInput;

    final shouldValidate = prevSearchInputState.isNotValid;

    final newSearchInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      searchInput: newSearchInputState,
    );

    emit(newState);
  }

  void onSearchUnfocused() {
    final prevState = state;
    final prevSearchInputState = prevState.searchInput;
    final prevSearchInputVal = prevSearchInputState.value;

    final newSearchInputState = TextFieldInput.validated(prevSearchInputVal);

    final newState = prevState.copyWith(
      searchInput: newSearchInputState,
    );

    emit(newState);
  }
}
