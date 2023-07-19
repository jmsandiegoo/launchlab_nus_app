import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/team/responses/get_team_home_data.dart';
import 'package:launchlab/src/domain/team/team_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/download_avatar_image_request.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/utils/failure.dart';

@immutable
class TeamHomeState extends Equatable {
  final List<TeamEntity> memberTeamData;
  final List<TeamEntity> ownerTeamData;
  final UserEntity? userData;
  final bool isLeading;
  final TeamHomeStatus status;
  final Failure? error;

  const TeamHomeState({
    this.memberTeamData = const [],
    this.ownerTeamData = const [],
    this.userData,
    this.isLeading = true,
    this.status = TeamHomeStatus.loading,
    this.error,
  });

  TeamHomeState copyWith({
    List<TeamEntity>? memberTeamData,
    List<TeamEntity>? ownerTeamData,
    UserEntity? userData,
    List? userAvatarURL,
    bool? isLeading,
    TeamHomeStatus? status,
    Failure? error,
  }) {
    return TeamHomeState(
      memberTeamData: memberTeamData ?? this.memberTeamData,
      ownerTeamData: ownerTeamData ?? this.ownerTeamData,
      userData: userData ?? this.userData,
      isLeading: isLeading ?? this.isLeading,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [memberTeamData, ownerTeamData, userData, isLeading, status, error];
}

enum TeamHomeStatus {
  loading,
  success,
  error,
}

class TeamHomeCubit extends Cubit<TeamHomeState> {
  final AuthRepository _authRepository;
  final TeamRepository _teamRepository;
  final UserRepository _userRepository;

  TeamHomeCubit(
      this._authRepository, this._teamRepository, this._userRepository)
      : super(const TeamHomeState());

  Future<void> handleSignOut() async {
    await _authRepository.signOut();
  }

//Emit state here, no longer need future builder.
  void getData() async {
    try {
      final GetTeamHomeData res = await _teamRepository.getTeamHomeData();
      List<Future<UserAvatarEntity?>> asyncOperations = [];

      asyncOperations.add(_userRepository.fetchUserAvatar(
          DownloadAvatarImageRequest(
              userId: res.user.id!, isSignedUrlEnabled: true)));
      List<UserAvatarEntity?> avatars = await Future.wait(asyncOperations);
      final UserEntity userData = res.user.copyWith(userAvatar: avatars[0]);

      final newState = state.copyWith(
          memberTeamData: res.memberTeams,
          ownerTeamData: res.ownerTeams,
          userData: userData,
          status: TeamHomeStatus.success);
      debugPrint('Home state emitted');
      emit(newState);
    } on Failure catch (error) {
      emit(state.copyWith(status: TeamHomeStatus.error, error: error));
    }
  }

  void loading() {
    emit(state.copyWith(status: TeamHomeStatus.loading));
  }

  void setIsLeadingState(bool value) {
    emit(state.copyWith(isLeading: value));
  }
}
