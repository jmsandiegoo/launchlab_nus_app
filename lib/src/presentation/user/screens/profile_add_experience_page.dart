import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/presentation/user/cubits/experience_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/experience_form.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../common/cubits/app_root_cubit.dart';

class ProfileAddExperiencePage extends StatelessWidget {
  const ProfileAddExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appRootCubit = BlocProvider.of<AppRootCubit>(context);
    return BlocProvider(
        create: (_) => ExperienceFormCubit(
            userRepository: UserRepository(Supabase.instance)),
        child: BlocConsumer<ExperienceFormCubit, ExperienceFormState>(
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
            return previous.experienceFormStatus !=
                current.experienceFormStatus;
          },
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              backgroundColor: lightGreyColor,
              leading: GestureDetector(
                onTap: () {
                  if (state.experienceFormStatus ==
                          ExperienceFormStatus.createLoading ||
                      state.experienceFormStatus ==
                          ExperienceFormStatus.updateLoading ||
                      state.experienceFormStatus ==
                          ExperienceFormStatus.deleteLoading) {
                    return;
                  }
                  navigatePopWithData(context, null, ActionTypes.cancel);
                },
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
                  BlocProvider.of<ExperienceFormCubit>(context).handleSubmit(
                      isApiCalled: true,
                      isEditMode: false,
                      createUserId: appRootCubit.state.session?.user.id ?? '');
                },
              ),
            ),
          ),
        ));
  }
}
