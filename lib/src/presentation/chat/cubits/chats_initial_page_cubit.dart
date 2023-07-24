import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';

class ChatsInitialPageState extends Equatable {
  const ChatsInitialPageState(
      {this.teamId, required this.chatsInitialPageStatus});

  final String? teamId;
  final ChatsInitialPageStatus chatsInitialPageStatus;

  ChatsInitialPageState copyWith({
    String? teamId,
    ChatsInitialPageStatus? chatsInitialPageStatus,
  }) {
    return ChatsInitialPageState(
      teamId: teamId,
      chatsInitialPageStatus:
          chatsInitialPageStatus ?? this.chatsInitialPageStatus,
    );
  }

  @override
  List<Object?> get props => [
        teamId,
        chatsInitialPageStatus,
      ];
}

enum ChatsInitialPageStatus {
  initial,
  redirect,
  empty,
  error,
}

class ChatsInitialPageCubit extends Cubit<ChatsInitialPageState> {
  ChatsInitialPageCubit({
    String? teamId,
    required this.teamRepository,
  }) : super(ChatsInitialPageState(
            teamId: teamId,
            chatsInitialPageStatus: ChatsInitialPageStatus.initial));

  final TeamRepository teamRepository;

  Future<void> handleInitialPage() async {
    emit(state.copyWith(
        chatsInitialPageStatus: ChatsInitialPageStatus.initial,
        teamId: state.teamId));

    if (state.teamId != null) {
      emit(state.copyWith(
          chatsInitialPageStatus: ChatsInitialPageStatus.redirect,
          teamId: state.teamId));
      return;
    }

    // fetch leading
    List<TeamEntity> leadingTeams = await teamRepository.getLeadingTeams("");

    if (leadingTeams.isNotEmpty) {
      emit(state.copyWith(
          chatsInitialPageStatus: ChatsInitialPageStatus.redirect,
          teamId: leadingTeams[0].id));
      return;
    }

    // fetch participating
    List<TeamEntity> participatingTeams =
        await teamRepository.getParticipatingTeams("");

    if (participatingTeams.isNotEmpty) {
      emit(state.copyWith(
          chatsInitialPageStatus: ChatsInitialPageStatus.redirect,
          teamId: participatingTeams[0].id));
      return;
    }

    debugPrint("here");
    emit(state.copyWith(
        chatsInitialPageStatus: ChatsInitialPageStatus.empty, teamId: null));
  }
}
