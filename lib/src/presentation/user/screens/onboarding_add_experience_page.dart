import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/user/cubits/experience_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/experience_form.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class OnboardingAddExperiencePage extends StatelessWidget {
  const OnboardingAddExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExperienceFormCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: lightGreyColor,
          leading: GestureDetector(
            onTap: () => navigatePopWithData(context, null, ActionTypes.cancel),
            child: const Icon(Icons.keyboard_backspace_outlined),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          // ignore: prefer_const_constructors
          child: ExperienceForm(
            isEditMode: false,
            onSubmitHandler: (context, state) {
              final isFormValid =
                  BlocProvider.of<ExperienceFormCubit>(context).validateForm();

              if (!isFormValid) {
                return;
              }

              navigatePopWithData<ExperienceEntity>(
                  context,
                  ExperienceEntity(
                    title: state.titleNameFieldInput.value,
                    companyName: state.companyNameFieldInput.value,
                    isCurrent: state.isCurrentFieldInput.value,
                    startDate: state.startDateFieldInput.value!,
                    endDate: state.endDateFieldInput.value,
                    description: state.descriptionFieldInput.value,
                  ),
                  ActionTypes.create);
            },
          ),
        ),
      ),
    );
  }
}

// each page will have cubit

// each form will then receive a custom cubit

