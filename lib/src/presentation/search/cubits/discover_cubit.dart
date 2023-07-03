import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/search/search_repository.dart';
import 'package:launchlab/src/domain/search/responses/get_search_result.dart';
import 'package:launchlab/src/domain/search/search_team_entity.dart';

@immutable
class DiscoverState extends Equatable {
  final String searchTerm;
  final List<SearchTeamEntity> externalTeamData;
  final String userId;
  final bool isLoaded;

  @override
  List<Object?> get props => [searchTerm, externalTeamData, userId, isLoaded];

  const DiscoverState(
      {this.searchTerm = "",
      this.externalTeamData = const [],
      this.userId = "",
      this.isLoaded = true});

  DiscoverState copyWith({
    String? searchTerm,
    List<SearchTeamEntity>? externalTeamData,
    String? userId,
    bool? isLoaded,
  }) {
    return DiscoverState(
      searchTerm: searchTerm ?? this.searchTerm,
      externalTeamData: externalTeamData ?? this.externalTeamData,
      userId: userId ?? this.userId,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit(this._searchRepository) : super(const DiscoverState());

  final SearchRepository _searchRepository;
  getData(searchTerm) async {
    emit(state.copyWith(isLoaded: false));
    final GetSearchResult res =
        await _searchRepository.getSearchData(searchTerm);
    final newState = state.copyWith(
        searchTerm: searchTerm,
        externalTeamData: res.uniqueSearchedTeams(),
        userId: res.userId,
        isLoaded: true);
    emit(newState);
  }
}
