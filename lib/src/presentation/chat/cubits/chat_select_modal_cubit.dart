import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/utils/extensions.dart';

class ChatSelectModalState extends Equatable {
  const ChatSelectModalState({
    this.searchInput = const TextFieldInput.unvalidated(),
    required this.selectedTeam,
    this.leadingTeams = const [],
    this.participatingTeams = const [],
    required this.chatSelectModalTab,
    required this.chatSelectModalStatus,
  });

  final TextFieldInput searchInput;
  final TeamEntity selectedTeam;
  final List<TeamEntity> leadingTeams;
  final List<TeamEntity> participatingTeams;
  final ChatSelectModalTab chatSelectModalTab;
  final ChatSelectModalStatus chatSelectModalStatus;

  ChatSelectModalState copyWith({
    TextFieldInput? searchInput,
    TeamEntity? selectedTeam,
    List<TeamEntity>? leadingTeams,
    List<TeamEntity>? participatingTeams,
    ChatSelectModalTab? chatSelectModalTab,
    ChatSelectModalStatus? chatSelectModalStatus,
  }) {
    return ChatSelectModalState(
      searchInput: searchInput ?? this.searchInput,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      leadingTeams: leadingTeams ?? this.leadingTeams,
      participatingTeams: participatingTeams ?? this.participatingTeams,
      chatSelectModalTab: chatSelectModalTab ?? this.chatSelectModalTab,
      chatSelectModalStatus:
          chatSelectModalStatus ?? this.chatSelectModalStatus,
    );
  }

  @override
  List<Object?> get props => [
        searchInput,
        selectedTeam,
        leadingTeams,
        participatingTeams,
        chatSelectModalTab,
        chatSelectModalStatus,
      ];
}

enum ChatSelectModalStatus { initial, loading, success, error }

enum ChatSelectModalTab { leading, participating }

extension ChatModalTabExt on ChatSelectModalTab {
  String text() {
    switch (this) {
      case ChatSelectModalTab.leading:
        return "Leading";
      case ChatSelectModalTab.participating:
        return "Participating";
    }
  }
}

class ChatSelectModalCubit extends Cubit<ChatSelectModalState> {
  ChatSelectModalCubit({
    required this.teamRepository,
    required TeamEntity selectedTeam,
    required ChatSelectModalTab chatSelectModalTab,
  }) : super(ChatSelectModalState(
          selectedTeam: selectedTeam,
          chatSelectModalTab: chatSelectModalTab,
          chatSelectModalStatus: ChatSelectModalStatus.initial,
        ));

  final TeamRepository teamRepository;

  void handleTabChange(ChatSelectModalTab chatSelectModalTab) {
    emit(state.copyWith(chatSelectModalTab: chatSelectModalTab));
  }

  Future<void> handleFetchLeadingTeams() async {
    emit(state.copyWith(chatSelectModalStatus: ChatSelectModalStatus.loading));
    // call the team api repository
    final List<TeamEntity> leadingTeams =
        await teamRepository.getLeadingTeams(state.searchInput.value);

    // sort it according to the current Selected team;
    int index =
        leadingTeams.indexWhere((team) => team.id == state.selectedTeam.id);

    if (index >= 0) {
      leadingTeams.move(index, 0);
    }

    // emit the state
    emit(state.copyWith(
        leadingTeams: leadingTeams,
        chatSelectModalStatus: ChatSelectModalStatus.success));
  }

  Future<void> handleFetchParticipatingTeams() async {
    emit(state.copyWith(chatSelectModalStatus: ChatSelectModalStatus.loading));

    // call the tea, api repository
    final List<TeamEntity> participatingTeams =
        await teamRepository.getParticipatingTeams(state.searchInput.value);

    // sort it according to the current participating team
    int index = participatingTeams
        .indexWhere((team) => team.id == state.selectedTeam.id);

    if (index >= 0) {
      participatingTeams.move(index, 0);
    }

    // emit the state
    emit(state.copyWith(
        participatingTeams: participatingTeams,
        chatSelectModalStatus: ChatSelectModalStatus.success));
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

    if (state.chatSelectModalTab == ChatSelectModalTab.leading) {
      handleFetchLeadingTeams();
    } else {
      handleFetchParticipatingTeams();
    }
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
