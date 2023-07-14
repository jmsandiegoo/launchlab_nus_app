import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/search/search_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/search/external_team_entity.dart';
import 'package:launchlab/src/domain/search/responses/get_external_team.dart';
import 'package:launchlab/src/domain/team/team_user_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/download_avatar_image_request.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';

@immutable
class ExternalTeamState extends Equatable {
  final ExternalTeamEntity? teamData;
  final TeamUserEntity? ownerData;
  final List currentApplicants;
  final List pastApplicants;
  final List currentMembers;
  final bool isLoaded;
  @override
  List<Object?> get props =>
      [teamData, currentApplicants, pastApplicants, currentMembers, isLoaded];

  const ExternalTeamState(
      {this.teamData,
      this.ownerData,
      this.currentApplicants = const [],
      this.pastApplicants = const [],
      this.currentMembers = const [],
      this.isLoaded = false});

  ExternalTeamState copyWith({
    ExternalTeamEntity? teamData,
    TeamUserEntity? ownerData,
    List? currentApplicants,
    List? pastApplicants,
    List? currentMembers,
    bool? isLoaded,
  }) {
    return ExternalTeamState(
      teamData: teamData ?? this.teamData,
      ownerData: ownerData ?? this.ownerData,
      currentApplicants: currentApplicants ?? this.currentApplicants,
      currentMembers: currentMembers ?? this.currentMembers,
      pastApplicants: pastApplicants ?? this.pastApplicants,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class ExternalTeamCubit extends Cubit<ExternalTeamState> {
  ExternalTeamCubit(this._searchRepository, this._userRepository)
      : super(const ExternalTeamState());

  final SearchRepository _searchRepository;
  final UserRepository _userRepository;

  void getData(teamId) async {
    final GetExternalTeam res =
        await _searchRepository.getExternalTeamData(teamId);
    final owner = res.getOwnerData();

    List<Future<UserAvatarEntity?>> asyncOperations = [];

    asyncOperations.add(_userRepository.fetchUserAvatar(
        DownloadAvatarImageRequest(
            userId: owner.user.id!, isSignedUrlEnabled: true)));
    List<UserAvatarEntity?> avatars = await Future.wait(asyncOperations);

    final ownerData =
        owner.copyWith(user: owner.user.copyWith(userAvatar: avatars[0]));

    final newState = state.copyWith(
        teamData: res.teamData,
        ownerData: ownerData,
        currentApplicants: res.getCurrentApplicants(),
        pastApplicants: res.getPastApplicants(),
        currentMembers: res.getCurrentMembers(),
        isLoaded: true);
    emit(newState);
  }

  applyToTeam({teamId, userId}) async {
    await _searchRepository.applyToTeam(teamId: teamId, userId: userId);
    debugPrint("Applied to Team");
  }

  reapplyToTeam({teamId, userId}) async {
    await _searchRepository.reapplyToTeam(teamId: teamId, userId: userId);
    debugPrint("Reapplied to Team");
  }
}
