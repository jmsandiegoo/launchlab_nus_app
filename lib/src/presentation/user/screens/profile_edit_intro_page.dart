import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/user_avatar_entity.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/user/cubits/intro_form_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/intro_form.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileEditIntroPageProps {
  const ProfileEditIntroPageProps({
    required this.userProfile,
    required this.userDegreeProgramme,
    this.userAvatar,
  });

  final UserEntity userProfile;
  final DegreeProgrammeEntity userDegreeProgramme;
  final UserAvatarEntity? userAvatar;
}

class ProfileEditIntroPage extends StatelessWidget {
  const ProfileEditIntroPage({super.key, required this.props});

  final ProfileEditIntroPageProps props;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return IntroFormCubit(
          userRepository: UserRepository(Supabase.instance),
          userProfile: props.userProfile,
          userDegreeProgramme: props.userDegreeProgramme,
          userAvatar: props.userAvatar,
        );
      },
      child: BlocConsumer<IntroFormCubit, IntroFormState>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            backgroundColor: lightGreyColor,
            leading: GestureDetector(
              onTap: () {
                final introFormCubit = BlocProvider.of<IntroFormCubit>(context);
                if (introFormCubit.state.introFormStatus ==
                    IntroFormStatus.loading) {
                  return;
                }

                if (introFormCubit.state.introFormStatus ==
                    IntroFormStatus.success) {
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
            child: const IntroForm(),
          ),
        ),
      ),
    );
  }
}
