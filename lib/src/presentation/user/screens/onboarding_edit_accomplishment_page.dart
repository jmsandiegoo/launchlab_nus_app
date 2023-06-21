import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/presentation/user/cubits/accomplishment_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/accomplishment_form.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class OnboardingEditAccomplishmentPage extends StatelessWidget {
  const OnboardingEditAccomplishmentPage({
    super.key,
    required this.accomplishment,
  });

  final AccomplishmentEntity accomplishment;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccomplishmentFormCubit.withDefaultValue(
          accomplishment: accomplishment),
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
              isEditMode: true,
              onSubmitHandler: (context, state) {
                navigatePopWithData<AccomplishmentEntity>(
                    context,
                    AccomplishmentEntity(
                        title: state.titleNameFieldInput.value,
                        issuer: state.issuerFieldInput.value,
                        isActive: state.isActiveFieldInput.value,
                        startDate: state.startDateFieldInput.value!,
                        endDate: state.endDateFieldInput.value,
                        description: state.descriptionFieldInput.value),
                    ActionTypes.update);
              },
              onDeleteHandler: (context, state) {
                navigatePopWithData<AccomplishmentEntity>(
                    context, null, ActionTypes.delete);
              },
            )),
      ),
    );
  }
}
