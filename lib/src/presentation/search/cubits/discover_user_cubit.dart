import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/search/search_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/search/responses/get_user_search_result.dart';
import 'package:launchlab/src/domain/user/models/requests/download_avatar_image_request.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/utils/failure.dart';

@immutable
class DiscoverUserState extends Equatable {
  final String searchTerm;
  final List<UserEntity> externalUserData;
  final DiscoverUserStatus status;
  final Failure? error;

  @override
  List<Object?> get props => [searchTerm, externalUserData, status, error];

  const DiscoverUserState(
      {this.searchTerm = '',
      this.externalUserData = const [],
      this.status = DiscoverUserStatus.success,
      this.error});

  DiscoverUserState copyWith({
    String? searchTerm,
    List<UserEntity>? externalUserData,
    DiscoverUserStatus? status,
    Failure? error,
  }) {
    return DiscoverUserState(
        searchTerm: searchTerm ?? this.searchTerm,
        externalUserData: externalUserData ?? this.externalUserData,
        status: status ?? this.status,
        error: error);
  }
}

enum DiscoverUserStatus {
  loading,
  success,
  error,
}

class DiscoverUserCubit extends Cubit<DiscoverUserState> {
  DiscoverUserCubit(this._searchRepository, this._userRepository)
      : super(const DiscoverUserState());
  final SearchRepository _searchRepository;
  final UserRepository _userRepository;

  void getSearchUserData(String searchUsername) async {
    try {
      emit(state.copyWith(status: DiscoverUserStatus.loading));

      final GetSearchUserResult res =
          await _searchRepository.getUserSearch(searchUsername);


      final List<UserEntity> userData = res.getFullUserData();
      List<Future<UserAvatarEntity?>> asyncOperations = [];

      for (int i = 0; i < userData.length; i++) {
        asyncOperations.add(_userRepository.fetchUserAvatar(
            DownloadAvatarImageRequest(
                userId: userData[i].id!, isSignedUrlEnabled: true)));
      }

      List<UserAvatarEntity?> avatars = await Future.wait(asyncOperations);

      for (int i = 0; i < userData.length; i++) {
        userData[i] = userData[i].copyWith(
            userAvatar: avatars[i],
            userDegreeProgramme: userData[i].userDegreeProgramme,
            userPreference: userData[i].userPreference,
            userAccomplishments: userData[i].userAccomplishments,
            userExperiences: userData[i].userExperiences);
      }
      final newState = state.copyWith(
          externalUserData: userData, status: DiscoverUserStatus.success);

      emit(newState);
    } on Failure catch (error) {
      emit(state.copyWith(status: DiscoverUserStatus.error, error: error));
    }
  }
}
