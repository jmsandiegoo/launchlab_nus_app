import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsContainerState extends Equatable {
  const ChatsContainerState({
    this.teamId,
  });

  final String? teamId;

  ChatsContainerState copyWith({
    String? teamId,
  }) {
    return ChatsContainerState(
      teamId: teamId,
    );
  }

  @override
  List<Object?> get props => [
        teamId,
      ];
}

class ChatsContainerCubit extends Cubit<ChatsContainerState> {
  ChatsContainerCubit({String? teamId})
      : super(ChatsContainerState(teamId: teamId));

  void setTeamId(String? teamId) {
    emit(state.copyWith(teamId: teamId));
  }
}
