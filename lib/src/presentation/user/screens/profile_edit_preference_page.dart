import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/presentation/user/cubits/preference_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/preference_form.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileEditPreferencePageProps {
  const ProfileEditPreferencePageProps({required this.userPreference});
  final PreferenceEntity userPreference;
}

class ProfileEditPreferencePage extends StatelessWidget {
  const ProfileEditPreferencePage({
    super.key,
    required this.props,
  });

  final ProfileEditPreferencePageProps props;

  @override
  Widget build(BuildContext context) {
    print("props: ${props.userPreference.categories}");
    return BlocProvider(
      create: (_) => PreferenceFormCubit(
          userRepository: UserRepository(Supabase.instance),
          commonRepository: CommonRepository(Supabase.instance),
          userPreference: props.userPreference)
        ..handleInitializeForm(),
      child: BlocConsumer<PreferenceFormCubit, PreferenceFormState>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            backgroundColor: lightGreyColor,
            leading: GestureDetector(
              onTap: () {
                if (state.preferenceFormStatus ==
                    PreferenceFormStatus.loading) {
                  return;
                }

                if (state.preferenceFormStatus ==
                    PreferenceFormStatus.success) {
                  navigatePopWithData(
                    context,
                    null,
                    ActionTypes.update,
                  );
                } else {
                  navigatePop(context);
                }
              },
              child: const Icon(Icons.keyboard_backspace_outlined),
            ),
          ),
          body: () {
            if (state.preferenceFormStatus == PreferenceFormStatus.initial ||
                state.preferenceFormStatus == PreferenceFormStatus.error) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: const PreferenceForm(),
            );
          }(),
        ),
      ),
    );
  }
}
