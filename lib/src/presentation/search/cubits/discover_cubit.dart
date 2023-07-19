import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/search/search_repository.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/search/responses/get_recomendation.dart';
import 'package:launchlab/src/domain/search/responses/get_search_result.dart';
import 'package:launchlab/src/domain/search/search_filter_entity.dart';
import 'package:launchlab/src/domain/search/search_team_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_skills_interests_field.dart';
import 'package:launchlab/src/utils/failure.dart';

@immutable
class DiscoverState extends Equatable {
  final String searchTerm;
  final List<SearchTeamEntity> externalTeamData;
  final List<UserEntity> externalUserData;
  final String userId;
  final String categoryInput;
  final String commitmentInput;
  final UserSkillsInterestsFieldInput interestInput;
  final List<SkillEntity> skillInterestOptions;
  final DiscoverStatus status;
  final Failure? error;

  @override
  List<Object?> get props => [
        searchTerm,
        externalTeamData,
        externalUserData,
        userId,
        categoryInput,
        commitmentInput,
        interestInput,
        skillInterestOptions,
        status,
        error
      ];

  const DiscoverState(
      {this.searchTerm = "",
      this.externalTeamData = const [],
      this.externalUserData = const [],
      this.userId = "",
      this.categoryInput = "",
      this.commitmentInput = "",
      this.interestInput = const UserSkillsInterestsFieldInput.unvalidated(),
      this.skillInterestOptions = const [],
      this.status = DiscoverStatus.loading,
      this.error});

  DiscoverState copyWith({
    String? searchTerm,
    List<SearchTeamEntity>? externalTeamData,
    List<UserEntity>? externalUserData,
    String? userId,
    String? categoryInput,
    String? commitmentInput,
    UserSkillsInterestsFieldInput? interestInput,
    List<SkillEntity>? skillInterestOptions,
    DiscoverStatus? status,
    Failure? error,
  }) {
    return DiscoverState(
        searchTerm: searchTerm ?? this.searchTerm,
        externalTeamData: externalTeamData ?? this.externalTeamData,
        externalUserData: externalUserData ?? this.externalUserData,
        userId: userId ?? this.userId,
        categoryInput: categoryInput ?? this.categoryInput,
        commitmentInput: commitmentInput ?? this.commitmentInput,
        interestInput: interestInput ?? this.interestInput,
        skillInterestOptions: skillInterestOptions ?? this.skillInterestOptions,
        status: status ?? this.status,
        error: error);
  }
}

enum DiscoverStatus {
  loading,
  success,
  error,
}

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit(this._commonRepository, this._searchRepository)
      : super(const DiscoverState());
  final CommonRepository _commonRepository;
  final SearchRepository _searchRepository;

  getData(String searchTerm, SearchFilterEntity filterData) async {
    try {
      emit(state.copyWith(status: DiscoverStatus.loading));
      final GetSearchResult res =
          await _searchRepository.getSearchData(searchTerm, filterData);
      final newState = state.copyWith(
          searchTerm: searchTerm,
          externalTeamData: res.uniqueSearchedTeams(),
          userId: res.userId,
          status: DiscoverStatus.success);
      emit(newState);
    } on Failure catch (error) {
      emit(state.copyWith(status: DiscoverStatus.error, error: error));
    }
  }

  getRecomendationData(filterData) async {
    try {
      emit(state.copyWith(status: DiscoverStatus.loading));
      final GetRecomendationResult res =
          await _searchRepository.getRecomendationData(filterData);

      final newState = state.copyWith(
          searchTerm: "",
          externalTeamData: res.getRecomendedTeams(),
          userId: res.userId,
          status: DiscoverStatus.success);
      emit(newState);
    } on Failure catch (error) {
      emit(state.copyWith(status: DiscoverStatus.error, error: error));
    }
  }

  void onCommitmentChanged(String val) {
    final newState = state.copyWith(commitmentInput: val);
    emit(newState);
  }

  void onCategoryChanged(String val) {
    final newState = state.copyWith(categoryInput: val);
    emit(newState);
  }

  Future<void> handleGetSkillsInterests(String? filter) async {
    try {
      final List<SkillEntity> skillInterestOptions =
          await _commonRepository.getSkillsInterestsFromEmsi(filter);
      emit(state.copyWith(skillInterestOptions: skillInterestOptions));
    } on Failure catch (error) {
      emit(state.copyWith(status: DiscoverStatus.error, error: error));
    }
  }

  void onInterestChanged(List<SkillEntity> val) {
    final newInputState = UserSkillsInterestsFieldInput.validated(val);
    final newState = state.copyWith(interestInput: newInputState);
    emit(newState);
  }

  void clearAll() {
    List<SkillEntity> interest = [];
    final newInterestInputState =
        UserSkillsInterestsFieldInput.validated(interest);

    final newState = state.copyWith(
        commitmentInput: "",
        categoryInput: "",
        interestInput: newInterestInputState);
    emit(newState);
  }

  void onFilterApply(SearchFilterEntity data) {
    final newInterestInputState =
        UserSkillsInterestsFieldInput.validated(data.interestInput);
    final newState = state.copyWith(
        categoryInput: data.categoryInput,
        commitmentInput: data.commitmentInput,
        interestInput: newInterestInputState);
    emit(newState);
  }
}
