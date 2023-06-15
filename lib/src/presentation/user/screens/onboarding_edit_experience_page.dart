import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/user/cubits/experience_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/experience_form.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class OnboardingEditExperiencePage extends StatelessWidget {
  const OnboardingEditExperiencePage({super.key, required this.experience});

  final ExperienceEntity experience;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ExperienceFormCubit.withDefaultValues(experience: experience),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: lightGreyColor,
          leading: GestureDetector(
            onTap: () => navigatePop(context),
            child: const Icon(Icons.keyboard_backspace_outlined),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: ExperienceForm(
            isEditMode: true,
            onSubmitHandler: (state) {
              navigatePopWithData(
                context,
                ExperienceEntity(
                  title: state.titleNameFieldInput.value,
                  companyName: state.companyNameFieldInput.value,
                  isCurrent: state.isCurrentFieldInput.value,
                  startDate: state.startDateFieldInput.value!,
                  endDate: state.endDateFieldInput.value,
                  description: state.descriptionFieldInput.value,
                ),
                ActionTypes.update,
              );
            },
            onDeleteHandler: (state) {
              navigatePopWithData<ExperienceEntity>(
                  context, null, ActionTypes.delete);
            },
          ),
        ),
      ),
    );
  }
}
