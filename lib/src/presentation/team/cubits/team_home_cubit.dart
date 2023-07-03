import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/team/responses/get_team_home_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/team/user_entity.dart';

@immutable
class TeamHomeState extends Equatable {
  final List<TeamEntity> memberTeamData;
  final List<TeamEntity> ownerTeamData;
  final UserEntity? userData;
  final bool isLeading;
  final bool isLoaded;

  const TeamHomeState({
    this.memberTeamData = const [],
    this.ownerTeamData = const [],
    this.userData,
    this.isLeading = true,
    this.isLoaded = false,
  });

  TeamHomeState copyWith({
    List<TeamEntity>? memberTeamData,
    List<TeamEntity>? ownerTeamData,
    UserEntity? userData,
    List? userAvatarURL,
    bool? isLeading,
    bool? isLoaded,
  }) {
    return TeamHomeState(
      memberTeamData: memberTeamData ?? this.memberTeamData,
      ownerTeamData: ownerTeamData ?? this.ownerTeamData,
      userData: userData ?? this.userData,
      isLeading: isLeading ?? this.isLeading,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }

  @override
  List<Object?> get props =>
      [memberTeamData, ownerTeamData, userData, isLeading, isLoaded];
}

class TeamHomeCubit extends Cubit<TeamHomeState> {
  final AuthRepository _authRepository;
  final TeamRepository _teamRepository;

  TeamHomeCubit(this._authRepository, this._teamRepository)
      : super(const TeamHomeState());

  Future<void> handleSignOut() async {
    await _authRepository.signOut();
  }

//Emit state here, no longer need future builder.
  void initData() async {
    final GetTeamHomeData res = await _teamRepository.getTeamHomeData();

    final newState = state.copyWith(
        memberTeamData: res.memberTeams,
        ownerTeamData: res.ownerTeams,
        userData: res.user,
        isLoaded: true);
    debugPrint('Home state emitted');
    emit(newState);
  }

  void setIsLeadingState(bool value) {
    emit(state.copyWith(isLeading: value));
  }
}
