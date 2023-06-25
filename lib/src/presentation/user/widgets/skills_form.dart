import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/dropwdown_search_field.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/skills_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_skills_interests_field.dart';

class SkillsForm extends StatefulWidget {
  const SkillsForm({super.key});

  @override
  State<SkillsForm> createState() => _SkillsFormState();
}

class _SkillsFormState extends State<SkillsForm> {
  late SkillsFormCubit _skillsFormCubit;

  @override
  void initState() {
    super.initState();
    _skillsFormCubit = BlocProvider.of<SkillsFormCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkillsFormCubit, SkillsFormState>(
      builder: (context, state) {
        return ListView(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headerText("Edit Skills"),
                      const SizedBox(
                        height: 15.0,
                      ),
                      bodyText(
                          "Here you can showcase your skills that you \nhave learnt and also your interests."),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            DropdownSearchFieldMultiWidget<SkillEntity>(
              focusNode: FocusNode(),
              label: "",
              getItems: (String filter) async {
                await _skillsFormCubit.handleGetSkillsInterests(filter);
                return _skillsFormCubit.state.skillInterestOptions;
              },
              selectedItems:
                  _skillsFormCubit.state.userSkillsInterestsInput.value,
              isChipsOutside: true,
              isFilterOnline: true,
              onChangedHandler: (values) =>
                  _skillsFormCubit.onUserSkillsInterestsChanged(values),
              compareFnHandler: (p0, p1) => p0.emsiId == p1.emsiId,
              errorText: state.userSkillsInterestsInput.displayError?.text(),
            ),
            primaryButton(
              context,
              () {
                _skillsFormCubit.handleSubmit();
              },
              "Save",
              isLoading: state.skillsFormStatus == SkillsFormStatus.loading,
              elevation: 0,
            ),
          ],
        );
      },
    );
  }
}
