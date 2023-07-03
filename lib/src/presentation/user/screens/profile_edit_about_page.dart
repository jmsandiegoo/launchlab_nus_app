import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/user/cubits/about_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/about_form.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileEditAboutPageProps {
  const ProfileEditAboutPageProps({
    required this.userProfile,
  });
  final UserEntity userProfile;
}

class ProfileEditAboutPage extends StatelessWidget {
  const ProfileEditAboutPage({
    super.key,
    required this.props,
  });

  final ProfileEditAboutPageProps props;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AboutFormCubit(
        userRepository: UserRepository(Supabase.instance),
        userProfile: props.userProfile,
      ),
      child: BlocConsumer<AboutFormCubit, AboutFormState>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            backgroundColor: lightGreyColor,
            leading: GestureDetector(
              onTap: () {
                if (state.aboutFormStatus == AboutFormStatus.loading) {
                  return;
                }

                if (state.aboutFormStatus == AboutFormStatus.success) {
                  navigatePopWithData(
                    context,
                    null,
                    ActionTypes.update,
                  );
                } else {
                  navigatePopWithData(context, null, ActionTypes.cancel);
                }
              },
              child: const Icon(Icons.keyboard_backspace_outlined),
            ),
          ),
          body: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: const AboutForm(),
          ),
        ),
      ),
    );
  }
}
