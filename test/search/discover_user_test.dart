import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/search/search_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/search/responses/get_user_search_result.dart';
import 'package:launchlab/src/presentation/search/cubits/discover_user_cubit.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockSearchRepository mockSearchRepository;
  late DiscoverUserCubit discoverUserCubit;
  late MockUserRepository mockUserRepository;

  group("Discover User Cubit", () {
    setUp(() {
      mockSearchRepository = MockSearchRepository();
      mockUserRepository = MockUserRepository();
      discoverUserCubit =
          DiscoverUserCubit(mockSearchRepository, mockUserRepository);
    });

    final Failure failure = Failure.request();

    const GetSearchUserResult searchUserResult = GetSearchUserResult([]);

    blocTest<DiscoverUserCubit, DiscoverUserState>(
      'emits [DiscoverUserStatus.loading, DiscoverUserStatus.success] when data is successfully loaded.',
      setUp: () => when(() => mockSearchRepository.getUserSearch(''))
          .thenAnswer((_) async => searchUserResult),
      build: () => discoverUserCubit,
      act: (cubit) => cubit.getSearchUserData(''),
      expect: () => <DiscoverUserState>[
        const DiscoverUserState(status: DiscoverUserStatus.loading),
        const DiscoverUserState(status: DiscoverUserStatus.success),
      ],
      verify: (_) async {
        verify(() => mockSearchRepository.getUserSearch('')).called(1);
      },
    );

    blocTest<DiscoverUserCubit, DiscoverUserState>(
      'Emits [DiscoverStatus.loading, DiscoverStatus.error] when failure is caught.',
      setUp: () =>
          when(() => mockSearchRepository.getUserSearch('')).thenThrow(failure),
      build: () => discoverUserCubit,
      act: (cubit) => cubit.getSearchUserData(''),
      expect: () => <DiscoverUserState>[
        const DiscoverUserState(status: DiscoverUserStatus.loading),
        DiscoverUserState(status: DiscoverUserStatus.error, error: failure),
      ],
      verify: (_) async {
        verify(() => mockSearchRepository.getUserSearch('')).called(1);
      },
    );
  });
}
