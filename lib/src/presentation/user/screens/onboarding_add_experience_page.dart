import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
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
      child: BlocListener<ExperienceFormCubit, ExperienceFormState>(
        listener: (context, state) {
          if (state.experienceFormStatus ==
              ExperienceFormStatus.createSuccess) {
            navigatePopWithData(
              context,
              state.experience,
              ActionTypes.create,
            );
          }
        },
        listenWhen: (previous, current) {
          return previous.experienceFormStatus != current.experienceFormStatus;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: lightGreyColor,
            leading: GestureDetector(
              onTap: () =>
                  navigatePopWithData(context, null, ActionTypes.cancel),
              child: const Icon(Icons.keyboard_backspace_outlined),
            ),
          ),
          body: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            // ignore: prefer_const_constructors
            child: ExperienceForm(
                isEditMode: false,
                onSubmitHandler: (context, state) {
                  BlocProvider.of<ExperienceFormCubit>(context)
                      .handleSubmit(isApiCalled: false, isEditMode: false);
                }),
          ),
        ),
      ),
    );
  }
}

// each page will have cubit

// each form will then receive a custom cubit

