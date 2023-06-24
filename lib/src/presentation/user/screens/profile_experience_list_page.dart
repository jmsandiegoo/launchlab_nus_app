import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/user/cubits/profile_experience_list_page_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/experience_list.dart';

class ProfileExperienceListPageProps {
  const ProfileExperienceListPageProps({
    required this.userExperiences,
    required this.userId,
  });
  final List<ExperienceEntity> userExperiences;
  final String userId;
}

class ProfileExperienceListPage extends StatelessWidget {
  const ProfileExperienceListPage({super.key, required this.props});

  final ProfileExperienceListPageProps props;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileExperienceListPageCubit(
        userExperiences: props.userExperiences,
        userId: props.userId,
      ),
      child: BlocConsumer<ProfileExperienceListPageCubit,
          ProfileExperienceListPageState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: lightGreyColor,
              leading: GestureDetector(
                onTap: () {},
                child: const Icon(Icons.keyboard_backspace_outlined),
              ),
              title: const Text("Experiences"),
              actions: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.add_outlined),
                ),
              ],
            ),
            body: ExperienceList(
              experiences: state.userExperiences.value,
              onChangedHandler: (p0) {},
            ),
          );
        },
      ),
    );
  }
}
