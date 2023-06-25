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

class ProfileEditAccomplishmentPage extends StatelessWidget {
  const ProfileEditAccomplishmentPage(
      {super.key, required this.accomplishment});

  final AccomplishmentEntity accomplishment;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => AccomplishmentFormCubit.withDefaultValues(
              userRepository: UserRepository(Supabase.instance),
              accomplishment: accomplishment,
            ),
        child: BlocConsumer<AccomplishmentFormCubit, AccomplishmentFormState>(
          listener: (context, state) {
            if (state.accomplishmentFormStatus ==
                AccomplishmentFormStatus.updateSuccess) {
              navigatePopWithData(
                context,
                state.accomplishment,
                ActionTypes.update,
              );
            }

            if (state.accomplishmentFormStatus ==
                AccomplishmentFormStatus.deleteSuccess) {
              navigatePopWithData<AccomplishmentEntity>(
                context,
                null,
                ActionTypes.delete,
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
                  navigatePopWithData<AccomplishmentEntity>(
                      context, null, ActionTypes.cancel);
                },
                child: const Icon(Icons.keyboard_backspace_outlined),
              ),
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: AccomplishmentForm(
                isEditMode: true,
                onSubmitHandler: (context, state) {
                  BlocProvider.of<AccomplishmentFormCubit>(context)
                      .handleSubmit(isApiCalled: true, isEditMode: true);
                },
                onDeleteHandler: (context, state) {
                  BlocProvider.of<AccomplishmentFormCubit>(context)
                      .handleDelete(isApiCalled: true);
                },
              ),
            ),
          ),
        ));
  }
}
