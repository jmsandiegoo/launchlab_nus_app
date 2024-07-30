import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/domain/common/models/category_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/feedback_toast.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/multi_button_select.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/preference_form_cubit.dart';
import 'package:launchlab/src/utils/toast_manager.dart';

class PreferenceForm extends StatefulWidget {
  const PreferenceForm({super.key});

  @override
  State<PreferenceForm> createState() => _PreferenceFormState();
}

class _PreferenceFormState extends State<PreferenceForm> {
  late PreferenceFormCubit _preferenceFormCubit;

  @override
  void initState() {
    super.initState();
    _preferenceFormCubit = BlocProvider.of<PreferenceFormCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreferenceFormCubit, PreferenceFormState>(
      listener: (context, state) {
        if (state.preferenceFormStatus == PreferenceFormStatus.success) {
          ToastManager().showFToast(
              child: const SuccessFeedback(msg: "Edit preference successful!"));
        }

        if (state.preferenceFormStatus == PreferenceFormStatus.error &&
            state.error != null) {
          ToastManager()
              .showFToast(child: ErrorFeedback(msg: state.error!.errorMessage));
        }
      },
      listenWhen: (previous, current) {
        return previous.preferenceFormStatus != current.preferenceFormStatus;
      },
      builder: (context, state) => ListView(
        children: [
          headerText("Account Settings"),
          const SizedBox(
            height: 20.0,
          ),
          headerText("Project Category Preference", size: 20.0),
          const SizedBox(
            height: 15.0,
          ),
          const LLBodyText(label:
              "Below are the categories you currently have interests in. You can change accordingly."),
          const SizedBox(
            height: 20.0,
          ),
          MultiButtonMultiSelectWidget(
            values: state.userPreferredCategoryInput.value,
            options: state.categoryOptions,
            colNo: 2,
            onPressHandler: (List<CategoryEntity> values) =>
                _preferenceFormCubit.onUserPreferredCategoryChanged(values),
            onCompareHandler: (option, values) {
              for (int i = 0; i < values.length; i++) {
                if (option.id == values[i].id) {
                  return true;
                }
              }

              return false;
            },
          ),
          const SizedBox(
            height: 30.0,
          ),
          primaryButton(
            context,
            () {
              _preferenceFormCubit.handleSubmit();
            },
            "Save",
            elevation: 0,
            isLoading:
                state.preferenceFormStatus == PreferenceFormStatus.loading,
          ),
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
