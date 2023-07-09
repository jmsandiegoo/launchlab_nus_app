import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/chat/chat_repository.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/team/responses/get_team_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/team_user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/utils/failure.dart';

class TeamChatsPageState extends Equatable {
  const TeamChatsPageState({
    this.searchInput = const TextFieldInput.unvalidated(),
    this.team,
    required this.teamChatsPageStatus,
    this.teamUsers = const [],
    this.error,
  });

  final TeamEntity? team;
  final List<TeamUserEntity> teamUsers;

  final TextFieldInput searchInput;
  final TeamChatsPageStatus teamChatsPageStatus;
  final Failure? error;

  TeamChatsPageState copyWith({
    TeamEntity? team,
    List<TeamUserEntity>? teamUsers,
    TextFieldInput? searchInput,
    TeamChatsPageStatus? teamChatsPageStatus,
    Failure? error,
  }) {
    return TeamChatsPageState(
      team: team ?? this.team,
      teamUsers: teamUsers ?? this.teamUsers,
      searchInput: searchInput ?? this.searchInput,
      teamChatsPageStatus: teamChatsPageStatus ?? this.teamChatsPageStatus,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        team,
        teamUsers,
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
  }) : super(const TeamChatsPageState(
          teamChatsPageStatus: TeamChatsPageStatus.initial,
        ));

  final ChatRepository chatRepository;
  final TeamRepository teamRepository;

  Future<void> handleInitializePage(String teamId) async {
    // fetch the team data
    final GetTeamData response = await teamRepository.getTeamData(teamId);
    TeamEntity team = response.team;

    // set up listener for team user

    // fetch team users data

    // fetch team chats
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
