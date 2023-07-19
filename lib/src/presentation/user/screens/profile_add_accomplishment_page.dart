import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/presentation/user/cubits/accomplishment_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/accomplishment_form.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../common/cubits/app_root_cubit.dart';

class ProfileAddAccomplishmentPage extends StatelessWidget {
  const ProfileAddAccomplishmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appRootCubit = BlocProvider.of<AppRootCubit>(context);
    return BlocProvider(
        create: (_) => AccomplishmentFormCubit(
            userRepository: UserRepository(Supabase.instance)),
        child: BlocConsumer<AccomplishmentFormCubit, AccomplishmentFormState>(
          listener: (context, state) {
            if (state.accomplishmentFormStatus ==
                AccomplishmentFormStatus.createSuccess) {
              navigatePopWithData(
                context,
                state.accomplishment,
                ActionTypes.create,
              );
            }
          },
          listenWhen: (previous, current) {
            return previous.accomplishmentFormStatus !=
                current.accomplishmentFormStatus;
          },
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              backgroundColor: lightGreyColor,
              leading: GestureDetector(
                onTap: () {
                  if (state.accomplishmentFormStatus ==
                          AccomplishmentFormStatus.createLoading ||
                      state.accomplishmentFormStatus ==
                          AccomplishmentFormStatus.updateLoading ||
                      state.accomplishmentFormStatus ==
                          AccomplishmentFormStatus.deleteLoading) {
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
              child: AccomplishmentForm(
                isEditMode: false,
                onSubmitHandler: (context, state) {
                  BlocProvider.of<AccomplishmentFormCubit>(context)
                      .handleSubmit(
                          isApiCalled: true,
                          isEditMode: false,
                          createUserId:
                              appRootCubit.state.session?.user.id ?? '');
                },
              ),
            ),
          ),
        ));
  }
}
