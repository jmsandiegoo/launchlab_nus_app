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
import 'package:launchlab/src/domain/user/models/requests/get_profile_info_request.dart';
import 'package:launchlab/src/domain/user/models/responses/get_profile_info_response.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/utils/failure.dart';

class TeamChatPageState extends Equatable {
  const TeamChatPageState({
    this.teamChat,
    this.userProfilesCache = const {},
    this.newMessageInput = const TextFieldInput.unvalidated(),
    this.teamChatPageStatus,
    this.error,
  });

  final TeamChatEntity? teamChat;
  final Map<String, UserEntity> userProfilesCache;
  final TextFieldInput newMessageInput;
  final TeamChatPageStatus? teamChatPageStatus;
  final Failure? error;

  TeamChatPageState copyWith({
    TeamChatEntity? teamChat,
    Map<String, UserEntity>? userProfilesCache,
    TextFieldInput? newMessageInput,
    TeamChatPageStatus? teamChatPageStatus,
    Failure? error,
  }) {
    return TeamChatPageState(
      teamChat: teamChat ?? this.teamChat,
      userProfilesCache: userProfilesCache ?? this.userProfilesCache,
      newMessageInput: newMessageInput ?? this.newMessageInput,
      teamChatPageStatus: teamChatPageStatus ?? this.teamChatPageStatus,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        teamChat,
        userProfilesCache,
        newMessageInput,
        teamChatPageStatus,
        error,
      ];
}

enum TeamChatPageStatus {
  initial,
  success,
  loading,
  error,
}

class TeamChatPageCubit extends Cubit<TeamChatPageState> {
  TeamChatPageCubit({
    required this.teamRepository,
    required this.chatRepository,
    required this.userRepository,
  }) : super(const TeamChatPageState(
            teamChatPageStatus: TeamChatPageStatus.initial));

  final ChatRepository chatRepository;
  final TeamRepository teamRepository;
  final UserRepository userRepository;

  Future<void> handleInitializePage(String chatId) async {
    // fetch team-chat with team
    TeamChatEntity teamChat = await _handleGetTeamChat(chatId);

    // fetch messages
    List<ChatMessageEntity> chatMessages =
        await _handleGetTeamChatMessages(chatId);

    // do other things such as fetching user and caching it;
    teamChat = teamChat.setMessages(messages: chatMessages);

    // setup message subscription

    emit(state.copyWith(
      teamChat: teamChat,
      teamChatPageStatus: TeamChatPageStatus.success,
    ));
  }

  Future<TeamChatEntity> _handleGetTeamChat(String chatId) async {
    TeamChatEntity teamChat =
        await chatRepository.getTeamChatByChatId(chatId: chatId);

    // fetch team details
    final GetTeamData res = await teamRepository.getTeamData(teamChat.teamId);
    Map<String, UserEntity> userProfilesCache = Map.of(state.userProfilesCache);
    TeamEntity team = res.team;

    teamChat = teamChat.setTeam(team: team);

    // cache chat users
    List<ChatUserEntity> chatUsers = [];

    for (int i = 0; i < teamChat.chatUsers.length; i++) {
      ChatUserEntity chatUser = teamChat.chatUsers[i];

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

    teamChat = teamChat.setChatUsers(chatUsers: chatUsers);

    emit(state.copyWith(
      teamChat: teamChat,
      userProfilesCache: userProfilesCache,
    ));

    return teamChat;
  }

  Future<List<ChatMessageEntity>> _handleGetTeamChatMessages(
    String chatId,
  ) async {
    Map<String, UserEntity> userProfilesCache = Map.of(state.userProfilesCache);

    List<ChatMessageEntity> chatMessages =
        await chatRepository.getTeamChatMessagesByChatId(chatId: chatId);

    // cache message sender users
    for (int i = 0; i < chatMessages.length; i++) {
      ChatMessageEntity message = chatMessages[i];

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

      chatMessages[i] = message;
    }

    emit(state.copyWith(userProfilesCache: userProfilesCache));

    return chatMessages;
  }
}
