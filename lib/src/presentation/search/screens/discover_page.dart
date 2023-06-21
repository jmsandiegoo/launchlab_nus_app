import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => DiscoverCubit(),
        child: BlocBuilder<DiscoverCubit, DiscoverState>(
            builder: (context, state) {
          final discoverCubit = BlocProvider.of<DiscoverCubit>(context);

          return FutureBuilder(
            future: discoverCubit.getData(state.searchTerm),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List shownTeams = [];

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
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: TextField(
                                      cursorColor: greyColor,
                                      controller: _searchController,
                                      onChanged: (value) =>
                                          discoverCubit.setSearchState(value),
                                      decoration: InputDecoration(
                                        fillColor: whiteColor,
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none),
                                        hintText: 'Search',
                                        hintStyle: const TextStyle(
                                            color: greyColor, fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  //
                                  InkWell(
                                    onTap: () {
                                      searchFilter();
                                      debugPrint("Filter");
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 10),
                                      decoration: BoxDecoration(
                                          color: blackColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                  if (snapshot.connectionState == ConnectionState.waiting) ...[
                    const Center(child: CircularProgressIndicator())
                  ],
                  if (snapshot.hasData) ...[
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          child: SingleChildScrollView(
                            child: Column(children: [
                              for (int i = 0;
                                  i < snapshot.data[0].length;
                                  i++) ...[
                                GestureDetector(
                                  onTap: () {
                                    navigatePushWithData(
                                        context, "/external_teams", [
                                      snapshot.data[0][i]['id'],
                                      snapshot.data[2]
                                    ]);
                                  },
                                  child: searchTeamCard(
                                      snapshot.data[0][i], shownTeams),
                                ),
                                const SizedBox(height: 10),
                              ],
                              for (int i = 0;
                                  i < snapshot.data[1].length;
                                  i++) ...[
                                GestureDetector(
                                  onTap: () {
                                    navigatePushWithData(
                                        context, "/external_teams", [
                                      snapshot.data[1][i]['id'],
                                      snapshot.data[2]
                                    ]);
                                  },
                                  child: searchTeamCard(
                                      snapshot.data[1][i], shownTeams),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ]),
                          )),
                    )
                  ] else
                    ...[]
                ]),
              );
            },
          );
        }));
  }

  Widget searchTeamCard(data, shownTeams) {
    String teamName = data['team_name'];
    int currentMember = data['current_members'];
    int maxMember = data['max_members'];
    String commitment = data['commitment'];
    String category = data['project_category'];

    if (shownTeams.contains(data['id'])) {
      debugPrint("Duplicates");
      return const SizedBox(height: 0);
    } else {
      shownTeams.add(data['id']);
    }

    return Container(
      width: double.infinity,
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            profilePicture(40, "test.jpeg"),
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
          bodyText("Frontend Developer, Mobile Developer, and more",
              size: 12.0),
          const SizedBox(height: 5),
          subHeaderText("Interest: ", size: 12.0),
          bodyText("blah blah waiting for format", size: 12.0),
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
