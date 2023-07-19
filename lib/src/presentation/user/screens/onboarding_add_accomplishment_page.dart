import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/presentation/user/cubits/accomplishment_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/accomplishment_form.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingAddAccomplishmentPage extends StatelessWidget {
  const OnboardingAddAccomplishmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccomplishmentFormCubit(
          userRepository: UserRepository(Supabase.instance)),
      child: BlocListener<AccomplishmentFormCubit, AccomplishmentFormState>(
        listener: (context, state) {
          if (state.accomplishmentFormStatus ==
              AccomplishmentFormStatus.createSuccess) {
            navigatePopWithData<AccomplishmentEntity>(
                context, state.accomplishment, ActionTypes.create);
          }
        },
        listenWhen: (previous, current) {
          return previous.accomplishmentFormStatus !=
              current.accomplishmentFormStatus;
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
            child: AccomplishmentForm(
              isEditMode: false,
              onSubmitHandler: (context, state) {
                BlocProvider.of<AccomplishmentFormCubit>(context)
                    .handleSubmit(isApiCalled: false, isEditMode: false);
              },
            ),
          ),
        ),
      ),
    );
  }
}
