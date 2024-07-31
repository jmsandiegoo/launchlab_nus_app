import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/authentication/repository/auth_repository.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/presentation/team/cubits/team_home_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/team_home_header.dart';
import 'package:launchlab/src/presentation/team/widgets/team_home_leading_list.dart';
import 'package:launchlab/src/presentation/team/widgets/team_home_participating_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamHomePage extends StatelessWidget {
  const TeamHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamHomeCubit(AuthRepository(Supabase.instance),
          TeamRepository(), UserRepository(Supabase.instance)),
      child: const TeamHomeContent(),
    );
  }
}

class TeamHomeContent extends StatefulWidget {
  const TeamHomeContent({super.key});

  @override
  State<TeamHomeContent> createState() => _TeamHomeState();
}

class _TeamHomeState extends State<TeamHomeContent> {
  late TeamHomeCubit teamHomeCubit;

  @override
  void initState() {
    super.initState();
    teamHomeCubit = BlocProvider.of<TeamHomeCubit>(context);
    teamHomeCubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamHomeCubit, TeamHomeState>(builder: (context, state) {
      return RefreshIndicator(
          onRefresh: () async {
            teamHomeCubit.loading();
            teamHomeCubit.getData();
          },
          child: state.status == TeamHomeStatus.success
              ? Scaffold(
                  backgroundColor: lightGreyColor,
                  body: Column(children: [
                      // ignore: prefer_const_constructors
                      TeamHomeHeader(),
                      const SizedBox(height: 10),
                      //Team Cards
                      Expanded(
                          child: state.isLeading
                              ? const TeamHomeLeadingList()
                              : const TeamHomeParticipatingList())
                    ]),
                )
              : const Center(child: CircularProgressIndicator()));
    });
  }
}
