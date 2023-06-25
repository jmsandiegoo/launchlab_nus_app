import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/common/models/category_entity.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/update_user_preference_request.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_preferred_category_field.dart';

class PreferenceFormState extends Equatable {
  const PreferenceFormState({
    this.userPreferredCategoryInput =
        const UserPreferredCategoryFieldInput.unvalidated(),
    this.categoryOptions = const [],
    required this.userPreference,
    required this.preferenceFormStatus,
  });

  final UserPreferredCategoryFieldInput userPreferredCategoryInput;
  final List<CategoryEntity> categoryOptions;
  final PreferenceEntity userPreference;
  final PreferenceFormStatus preferenceFormStatus;

  PreferenceFormState copyWith({
    UserPreferredCategoryFieldInput? userPreferredCategoryInput,
    List<CategoryEntity>? categoryOptions,
    PreferenceEntity? userPreference,
    PreferenceFormStatus? preferenceFormStatus,
  }) {
    return PreferenceFormState(
      userPreferredCategoryInput:
          userPreferredCategoryInput ?? this.userPreferredCategoryInput,
      categoryOptions: categoryOptions ?? this.categoryOptions,
      userPreference: userPreference ?? this.userPreference,
      preferenceFormStatus: preferenceFormStatus ?? this.preferenceFormStatus,
    );
  }

  @override
  List<Object?> get props => [
        userPreferredCategoryInput,
        categoryOptions,
        userPreference,
        preferenceFormStatus,
      ];
}

enum PreferenceFormStatus {
  initial,
  loading,
  success,
  error,
}

class PreferenceFormCubit extends Cubit<PreferenceFormState> {
  PreferenceFormCubit(
      {required this.userRepository,
      required this.commonRepository,
      required PreferenceEntity userPreference})
      : super(PreferenceFormState(
          userPreferredCategoryInput:
              UserPreferredCategoryFieldInput.unvalidated(
                  userPreference.categories),
          userPreference: userPreference,
          preferenceFormStatus: PreferenceFormStatus.initial,
        ));

  final UserRepository userRepository;
  final CommonRepository commonRepository;

  void onUserPreferredCategoryChanged(List<CategoryEntity> val) {
    final newUserPreferredCategoryInputState =
        UserPreferredCategoryFieldInput.validated(val);

    final newState = state.copyWith(
      userPreferredCategoryInput: newUserPreferredCategoryInputState,
    );

    emit(newState);
  }

  Future<void> handleInitializeForm() async {
    try {
      emit(state.copyWith(preferenceFormStatus: PreferenceFormStatus.initial));
      // loading state
      final List<CategoryEntity> categoryOptions =
          await commonRepository.getCategories();

      emit(state.copyWith(
          categoryOptions: categoryOptions,
          preferenceFormStatus: PreferenceFormStatus.success));
      // not loading state
    } on Exception catch (error) {
      print("error occured ${error}");
      emit(state.copyWith(preferenceFormStatus: PreferenceFormStatus.error));
    }
  }

  Future<void> handleSubmit() async {
    final userPreferredCategoryInput =
        UserPreferredCategoryFieldInput.validated(
            state.userPreferredCategoryInput.value);

    final isFormValid = Formz.validate([
      userPreferredCategoryInput,
    ]);

    if (!isFormValid) {
      emit(state.copyWith(
          userPreferredCategoryInput: userPreferredCategoryInput));
      return;
    }

    try {
      emit(state.copyWith(preferenceFormStatus: PreferenceFormStatus.loading));
      await userRepository.updateUserPreference(
        UpdateUserPreferenceRequest(
          userPreference: state.userPreference.copyWith(
            categories: state.userPreferredCategoryInput.value,
          ),
        ),
      );

      emit(state.copyWith(preferenceFormStatus: PreferenceFormStatus.success));
    } on Exception catch (_) {
      emit(state.copyWith(preferenceFormStatus: PreferenceFormStatus.error));
    }
  }
}
