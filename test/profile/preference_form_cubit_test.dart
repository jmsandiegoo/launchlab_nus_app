import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/common/models/category_entity.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_preference_request.dart';
import 'package:launchlab/src/presentation/user/cubits/preference_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_preferred_category_field.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockCommonRepository extends Mock implements CommonRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late MockCommonRepository mockCommonRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockCommonRepository = MockCommonRepository();
  });

  group("[Profile] PreferenceFormCubit Test:", () {
    final List<CategoryEntity> categoriesData = [
      const CategoryEntity(id: "123", name: "test"),
      const CategoryEntity(id: "456", name: "test2")
    ];

    const PreferenceEntity preference = PreferenceEntity(
      id: "123",
      userId: "123",
      categories: [
        CategoryEntity(id: "123", name: "test"),
        CategoryEntity(id: "456", name: "test2")
      ],
      skillsInterests: [],
    );

    blocTest<PreferenceFormCubit, PreferenceFormState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [categoryOptions, preferenceFormStatus.success] preference form initialize successful",
        // define mock behavior for this test case
        setUp: () {
          when(() => mockCommonRepository.getCategories())
              .thenAnswer((_) async => categoriesData);
        },
        // building the cubit including mock behaviors
        build: () => PreferenceFormCubit(
              userRepository: mockUserRepository,
              commonRepository: mockCommonRepository,
              userPreference: preference,
            ),
        // what the cubit should do
        act: (cubit) => cubit.handleInitializeForm(),
        // after calling method what is the expected state
        expect: () => [
              PreferenceFormState(
                userPreferredCategoryInput:
                    UserPreferredCategoryFieldInput.unvalidated(
                        preference.categories),
                userPreference: preference,
                preferenceFormStatus: PreferenceFormStatus.initial,
              ),
              PreferenceFormState(
                userPreferredCategoryInput:
                    UserPreferredCategoryFieldInput.unvalidated(
                        preference.categories),
                categoryOptions: categoriesData,
                userPreference: preference,
                preferenceFormStatus: PreferenceFormStatus.success,
              ),
            ],
        verify: (_) async {
          verify(() => mockCommonRepository.getCategories()).called(1);
        });

    blocTest<PreferenceFormCubit, PreferenceFormState>(
      // description including a list of emitted states and the cubit method
      // called, as well as the exptected output
      "emits [newUserPreferredCategoryInputState] when preferred category input changes",
      // define mock behavior for this test case
      setUp: () {},
      // building the cubit including mock behaviors
      build: () => PreferenceFormCubit(
        userRepository: mockUserRepository,
        commonRepository: mockCommonRepository,
        userPreference: preference,
      ),
      // what the cubit should do
      act: (cubit) => cubit.onUserPreferredCategoryChanged(categoriesData),
      // after calling method what is the expected state
      expect: () => [
        PreferenceFormState(
          userPreferredCategoryInput:
              UserPreferredCategoryFieldInput.validated(categoriesData),
          userPreference: preference,
          preferenceFormStatus: PreferenceFormStatus.initial,
        ),
      ],
    );

    blocTest<PreferenceFormCubit, PreferenceFormState>(
        // description including a list of emitted states and the cubit method
        // called, as well as the exptected output
        "emits [preferenceFormStatus.success] preference form submit successful",
        // define mock behavior for this test case
        setUp: () {
          registerFallbackValue(
              const UpdateUserPreferenceRequest(userPreference: preference));
          when(() => mockUserRepository.updateUserPreference(any()))
              .thenAnswer((_) async {});
        },
        // building the cubit including mock behaviors
        build: () => PreferenceFormCubit(
              userRepository: mockUserRepository,
              commonRepository: mockCommonRepository,
              userPreference: preference,
            ),
        // what the cubit should do
        act: (cubit) => cubit.handleSubmit(),
        // after calling method what is the expected state
        expect: () => [
              PreferenceFormState(
                userPreference: preference,
                userPreferredCategoryInput:
                    UserPreferredCategoryFieldInput.unvalidated(
                        preference.categories),
                preferenceFormStatus: PreferenceFormStatus.loading,
              ),
              PreferenceFormState(
                userPreference: preference,
                userPreferredCategoryInput:
                    UserPreferredCategoryFieldInput.unvalidated(
                        preference.categories),
                preferenceFormStatus: PreferenceFormStatus.success,
              ),
            ],
        verify: (_) async {
          verify(() => mockUserRepository.updateUserPreference(any()))
              .called(1);
        });
  });
}
