import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/user/cubits/about_form_cubit.dart';
import 'package:launchlab/src/presentation/user/cubits/skills_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/about_form.dart';
import 'package:launchlab/src/presentation/user/widgets/skills_form.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileEditSkillsPageProps {
  const ProfileEditSkillsPageProps({required this.userPreference});
  final PreferenceEntity userPreference;
}

class ProfileEditSkillsPage extends StatelessWidget {
  const ProfileEditSkillsPage({
    super.key,
    required this.props,
  });

  final ProfileEditSkillsPageProps props;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SkillsFormCubit(
        commonRepository: CommonRepository(Supabase.instance),
        userRepository: UserRepository(Supabase.instance),
        userPreference: props.userPreference,
      ),
      child: BlocConsumer<SkillsFormCubit, SkillsFormState>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            backgroundColor: lightGreyColor,
            leading: GestureDetector(
              onTap: () {
                if (state.skillsFormStatus == SkillsFormStatus.loading) {
                  return;
                }

                if (state.skillsFormStatus == SkillsFormStatus.success) {
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
          body: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: const SkillsForm(),
          ),
        ),
      ),
    );
  }
}
