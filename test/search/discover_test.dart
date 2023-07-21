import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/search/search_repository.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/search/responses/get_recomendation.dart';
import 'package:launchlab/src/domain/search/responses/get_search_result.dart';
import 'package:launchlab/src/domain/search/search_filter_entity.dart';
import 'package:launchlab/src/presentation/search/cubits/discover_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_skills_interests_field.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

class MockCommonRepository extends Mock implements CommonRepository {}

void main() {
  late MockSearchRepository mockSearchRepository;
  late DiscoverCubit discoverCubit;
  late MockCommonRepository mockCommonRepository;

  group("Discover Cubit", () {
    setUp(() async {
      mockSearchRepository = MockSearchRepository();
      mockCommonRepository = MockCommonRepository();

      discoverCubit = DiscoverCubit(mockCommonRepository, mockSearchRepository);
    });

    blocTest<DiscoverCubit, DiscoverState>(
      "emits [newOnCategoryChangedState] when project category changes",
      setUp: () {},
      build: () => discoverCubit,
      act: (cubit) => cubit.onCategoryChanged('Personal'),
      expect: () => [const DiscoverState(categoryInput: 'Personal')],
    );

    blocTest<DiscoverCubit, DiscoverState>(
      "emits [newOnCommitmentChangedState] when commitment changes",
      setUp: () {},
      build: () => discoverCubit,
      act: (cubit) => cubit.onCommitmentChanged('High'),
      expect: () => [const DiscoverState(commitmentInput: 'High')],
    );

    final List<SkillEntity> skillsInterestsData = [
      const SkillEntity(emsiId: "", name: ""),
    ];

    blocTest<DiscoverCubit, DiscoverState>(
        "emits [skillInterestOptions] when get skills interests successful",
        setUp: () {
          when(() => mockCommonRepository.getSkillsInterestsFromEmsi(any()))
              .thenAnswer((invocation) async => skillsInterestsData);
        },
        build: () => discoverCubit,
        act: (cubit) => cubit.handleGetSkillsInterests("test"),
        expect: () =>
            [DiscoverState(skillInterestOptions: skillsInterestsData)],
        verify: (_) async {
          verify(() => mockCommonRepository.getSkillsInterestsFromEmsi(any()))
              .called(1);
        });

    blocTest<DiscoverCubit, DiscoverState>(
      "emits [newOnInterestChangedState] when interests changes",
      setUp: () {},
      build: () => discoverCubit,
      act: (cubit) => cubit.onInterestChanged(skillsInterestsData),
      expect: () => [
        DiscoverState(
            interestInput:
                UserSkillsInterestsFieldInput.validated(skillsInterestsData))
      ],
    );

    blocTest<DiscoverCubit, DiscoverState>(
      "emits [newCategoryInputState, newCommitmentInputState, newInteresInputState] when filter is cleared",
      setUp: () {},
      build: () => discoverCubit,
      act: (cubit) => cubit.clearAll(),
      expect: () => [
        const DiscoverState(
            commitmentInput: '',
            categoryInput: '',
            interestInput: UserSkillsInterestsFieldInput.validated())
      ],
    );

    const SearchFilterEntity filter = SearchFilterEntity();

    blocTest<DiscoverCubit, DiscoverState>(
      "emits [newCategoryInputState, newCommitmentInputState, newInteresInputState] when filter changed",
      setUp: () {},
      build: () => discoverCubit,
      act: (cubit) => cubit.onFilterApply(filter),
      expect: () => [
        DiscoverState(
            commitmentInput: filter.categoryInput,
            categoryInput: filter.commitmentInput,
            interestInput:
                UserSkillsInterestsFieldInput.validated(filter.interestInput))
      ],
    );

    final Failure failure = Failure.request();

    const GetSearchResult searchResult = GetSearchResult([], '');

    blocTest<DiscoverCubit, DiscoverState>(
      'emits [DiscoverStatus.loading, DiscoverStatus.success] when data is successfully loaded.',
      setUp: () => when(() => mockSearchRepository.getSearchData('', filter))
          .thenAnswer((_) async => searchResult),
      build: () => discoverCubit,
      act: (cubit) => cubit.getData('', filter),
      expect: () => <DiscoverState>[
        const DiscoverState(status: DiscoverStatus.loading),
        const DiscoverState(status: DiscoverStatus.success),
      ],
      verify: (_) async {
        verify(() => mockSearchRepository.getSearchData('', filter)).called(1);
      },
    );

    blocTest<DiscoverCubit, DiscoverState>(
      'emits [DiscoverStatus.loading, DiscoverStatus.success] when recommendation data is successfully loaded.',
      setUp: () => when(() => mockSearchRepository.getRecomendationData(filter))
          .thenAnswer((_) async => const GetRecomendationResult([], '', {})),
      build: () => discoverCubit,
      act: (cubit) => cubit.getRecomendationData(filter),
      expect: () => <DiscoverState>[
        const DiscoverState(status: DiscoverStatus.loading),
        const DiscoverState(status: DiscoverStatus.success),
      ],
      verify: (_) async {
        verify(() => mockSearchRepository.getRecomendationData(filter))
            .called(1);
      },
    );

    blocTest<DiscoverCubit, DiscoverState>(
      'emits [DiscoverStatus.loading, DiscoverStatus.error] when failure is caught during getData.',
      setUp: () => when(() => mockSearchRepository.getSearchData('', filter))
          .thenThrow(failure),
      build: () => discoverCubit,
      act: (cubit) => cubit.getData('', filter),
      expect: () => <DiscoverState>[
        const DiscoverState(status: DiscoverStatus.loading),
        DiscoverState(status: DiscoverStatus.error, error: failure),
      ],
      verify: (_) async {
        verify(() => mockSearchRepository.getSearchData('', filter)).called(1);
      },
    );

    blocTest<DiscoverCubit, DiscoverState>(
      'emits [DiscoverStatus.loading, DiscoverStatus.error] when failure is caught during get Recommendation.',
      setUp: () => when(() => mockSearchRepository.getRecomendationData(filter))
          .thenThrow(failure),
      build: () => discoverCubit,
      act: (cubit) => cubit.getRecomendationData(filter),
      expect: () => <DiscoverState>[
        const DiscoverState(status: DiscoverStatus.loading),
        DiscoverState(status: DiscoverStatus.error, error: failure),
      ],
      verify: (_) async {
        verify(() => mockSearchRepository.getRecomendationData(filter))
            .called(1);
      },
    );
  });
}
