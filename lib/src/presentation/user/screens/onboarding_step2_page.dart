import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/domain/common/models/category_entity.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/dropwdown_search_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/multi_button_select.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_cubit.dart';

class OnboardingStep2Page extends StatelessWidget {
  const OnboardingStep2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      // ignore: prefer_const_constructors
      builder: (context, state) => OnboardingStep2Content(),
    );
  }
}

class OnboardingStep2Content extends StatefulWidget {
  const OnboardingStep2Content({super.key});

  @override
  State<OnboardingStep2Content> createState() => _OnboardingStep2ContentState();
}

class _OnboardingStep2ContentState extends State<OnboardingStep2Content> {
  late OnboardingCubit _onboardingCubit;

  @override
  void initState() {
    super.initState();
    _onboardingCubit = BlocProvider.of<OnboardingCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        headerText("State your skills & interests"),
        const SizedBox(
          height: 10.0,
        ),
        bodyText(
            "You can showcase your skills that you have learnt and also your interests."),
        const SizedBox(
          height: 20.0,
        ),
        DropdownSearchFieldMultiWidget<SkillEntity>(
          focusNode: FocusNode(),
          label: "",
          getItems: (String filter) async {
            await _onboardingCubit.handleGetSkillsInterests(filter);
            return _onboardingCubit.state.skillInterestOptions;
          },
          selectedItems: _onboardingCubit.state.userSkillsInterestsInput.value,
          isChipsOutside: true,
          isFilterOnline: true,
          onChangedHandler: (values) =>
              _onboardingCubit.onUserSkillsInterestsChanged(values),
        ),
        const SizedBox(
          height: 20.0,
        ),
        headerText("Project Category"),
        const SizedBox(
          height: 10.0,
        ),
        bodyText(
            "Specify the kind of category you are interested to work in. You could select more than one."),
        const SizedBox(
          height: 20.0,
        ),
        MultiButtonMultiSelectWidget(
          values: _onboardingCubit.state.userPreferredCategoryInput.value,
          options: _onboardingCubit.state.categoryOptions,
          colNo: 2,
          onPressHandler: (List<CategoryEntity> values) =>
              _onboardingCubit.onUserPreferredCategoryChanged(values),
        ),
      ],
    );
  }
}
