import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/user/cubits/experience_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/experience_form.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingEditExperiencePage extends StatelessWidget {
  const OnboardingEditExperiencePage({super.key, required this.experience});

  final ExperienceEntity experience;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExperienceFormCubit.withDefaultValues(
          userRepository: UserRepository(Supabase.instance),
          experience: experience),
      child: BlocListener<ExperienceFormCubit, ExperienceFormState>(
        listener: (context, state) {
          if (state.experienceFormStatus ==
              ExperienceFormStatus.updateSuccess) {
            navigatePopWithData(
              context,
              state.experience,
              ActionTypes.update,
            );
          }

          if (state.experienceFormStatus ==
              ExperienceFormStatus.deleteSuccess) {
            navigatePopWithData<ExperienceEntity>(
                context, null, ActionTypes.delete);
          }
        },
        listenWhen: (previous, current) {
          return previous.experienceFormStatus != current.experienceFormStatus;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: lightGreyColor,
            leading: GestureDetector(
              onTap: () => navigatePop(context),
              child: const Icon(Icons.keyboard_backspace_outlined),
            ),
          ),
          body: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: ExperienceForm(
              isEditMode: true,
              onSubmitHandler: (context, state) {
                BlocProvider.of<ExperienceFormCubit>(context)
                    .handleSubmit(isApiCalled: false, isEditMode: true);
              },
              onDeleteHandler: (context, state) {
                BlocProvider.of<ExperienceFormCubit>(context)
                    .handleDelete(isApiCalled: false);
              },
            ),
          ),
        ),
      ),
    );
  }
}
