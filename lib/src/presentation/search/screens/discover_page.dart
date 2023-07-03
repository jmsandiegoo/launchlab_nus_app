import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/search/search_repository.dart';
import 'package:launchlab/src/domain/search/search_team_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/search/cubits/discover_cubit.dart';
import 'package:launchlab/src/presentation/search/widgets/search_filter.dart';
import 'package:launchlab/src/utils/helper.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final TextEditingController _searchController = TextEditingController();

  FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => DiscoverCubit(SearchRepository()),
        child: BlocBuilder<DiscoverCubit, DiscoverState>(
            builder: (context, state) {
          final discoverCubit = BlocProvider.of<DiscoverCubit>(context);

          return Scaffold(
            body: Column(children: [
              Stack(children: [
                Image.asset("assets/images/yellow_curve_shape_3.png"),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      Row(children: [
                        const SizedBox(width: 20),
                        headerText("Find Teams"),
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          height: 45,
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: TextField(
                                  focusNode: FocusNode(),
                                  cursorColor: greyColor,
                                  controller: _searchController,
                                  onChanged: (value) =>
                                      discoverCubit.getData(value),
                                  decoration: InputDecoration(
                                    fillColor: whiteColor,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    hintText:
                                        'Search (Eg: Project / Orbital / Interest)',
                                    hintStyle: const TextStyle(
                                        color: greyColor, fontSize: 13),
                                  ),
                                ),
                              ),
                              //
                              InkWell(
                                onTap: () {
                                  //searchFilter();
                                  debugPrint("Filter");
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: blackColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: 50,
                                  child: const Icon(
                                    Icons.filter_alt_outlined,
                                    color: Colors.yellow,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
              ]),
              if (discoverCubit.state.isLoaded) ...[
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          for (int i = 0;
                              i < discoverCubit.state.externalTeamData.length;
                              i++) ...[
                            GestureDetector(
                              onTap: () {
                                searchFocusNode.unfocus();
                                navigatePushWithData(
                                    context, "/external_teams", [
                                  discoverCubit.state.externalTeamData[i].id,
                                  discoverCubit.state.userId
                                ]);
                              },
                              child: searchTeamCard(
                                  discoverCubit.state.externalTeamData[i]),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ]),
                      )),
                )
              ] else ...[
                const Center(child: CircularProgressIndicator())
              ]
            ]),
          );
        }));
  }

  Widget searchTeamCard(SearchTeamEntity data) {
    String teamName = data.teamName;
    int currentMember = data.currentMembers;
    int maxMember = data.maxMembers;
    String commitment = data.commitment;
    String category = data.category;
    String allInterest = data.getInterests();
    String allRoles = data.getRoles();
    String avatarURL = data.avatarURL;

    return Container(
      width: double.infinity,
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            teamPicture(40, avatarURL),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              subHeaderText(teamName),
              const SizedBox(height: 5),
              Row(children: [
                const Icon(Icons.people_alt_outlined, size: 12),
                const SizedBox(width: 5),
                subHeaderText("$currentMember / $maxMember", size: 12.0),
              ]),
            ]),
          ]),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            boldFirstText("Category: ", category),
            boldFirstText("Commitment level: ", commitment),
            const SizedBox(width: 5)
          ]),
          const SizedBox(height: 10),
          subHeaderText("Roles Needed: ", size: 12.0),
          allRoles == ''
              ? overflowText('Any', size: 12.0, maxLines: 1)
              : overflowText(allRoles, size: 12.0, maxLines: 1),
          const SizedBox(height: 5),
          subHeaderText("Interest: ", size: 12.0),
          overflowText(allInterest, size: 12.0, maxLines: 2),
        ]),
      ),
    );
  }

  final _controller = TextEditingController();
  void searchFilter() {
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        context: context,
        builder: (context) {
          return SearchFilterBox(controller: _controller);
        });
  }
}
