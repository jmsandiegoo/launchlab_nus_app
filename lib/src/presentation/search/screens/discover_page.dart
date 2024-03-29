import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/search/search_repository.dart';
import 'package:launchlab/src/domain/search/search_filter_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/search/cubits/discover_cubit.dart';
import 'package:launchlab/src/presentation/search/widgets/search_filter.dart';
import 'package:launchlab/src/presentation/search/widgets/search_team_card.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiscoverCubit(
          CommonRepository(Supabase.instance), SearchRepository()),
      child: const DiscoverPageContent(),
    );
  }
}

class DiscoverPageContent extends StatefulWidget {
  const DiscoverPageContent({Key? key}) : super(key: key);

  @override
  State<DiscoverPageContent> createState() => _DiscoverPageContentState();
}

class _DiscoverPageContentState extends State<DiscoverPageContent> {
  final TextEditingController _searchController = TextEditingController();
  late DiscoverCubit discoverCubit;

  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    discoverCubit = BlocProvider.of<DiscoverCubit>(context);
    discoverCubit.getRecomendationData(SearchFilterEntity(
        categoryInput: discoverCubit.state.categoryInput,
        commitmentInput: discoverCubit.state.commitmentInput,
        interestInput: discoverCubit.state.interestInput.value));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(builder: (context, state) {
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
                    height: 60,
                  ),
                  Row(children: [
                    const SizedBox(width: 20),
                    headerText("Find Teams"),
                  ]),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      height: 45,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: TextField(
                              focusNode: searchFocusNode,
                              cursorColor: greyColor,
                              controller: _searchController,
                              onChanged: (value) => value == ''
                                  ? discoverCubit.getRecomendationData(
                                      SearchFilterEntity(
                                          categoryInput:
                                              discoverCubit.state.categoryInput,
                                          commitmentInput: discoverCubit
                                              .state.commitmentInput,
                                          interestInput: discoverCubit
                                              .state.interestInput.value))
                                  : discoverCubit.getData(
                                      value,
                                      SearchFilterEntity(
                                          categoryInput:
                                              discoverCubit.state.categoryInput,
                                          commitmentInput: discoverCubit
                                              .state.commitmentInput,
                                          interestInput: discoverCubit
                                              .state.interestInput.value)),
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
                          InkWell(
                            onTap: () {
                              searchFilter(
                                  discoverCubit,
                                  SearchFilterEntity(
                                      categoryInput:
                                          discoverCubit.state.categoryInput,
                                      commitmentInput:
                                          discoverCubit.state.commitmentInput,
                                      interestInput: discoverCubit
                                          .state.interestInput.value));
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
                  const SizedBox(height: 5),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: blackColor,
                              side:
                                  const BorderSide(width: 1, color: blackColor),
                              minimumSize: const Size.fromRadius(15),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20)),
                          onPressed: () {
                            debugPrint('Team');
                          },
                          child: const Text(
                            "Team",
                            style: TextStyle(color: whiteColor, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: whiteColor,
                              side:
                                  const BorderSide(width: 1, color: blackColor),
                              minimumSize: const Size.fromRadius(15),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20)),
                          onPressed: () {
                            navigateGo(context, '/discover_user');
                          },
                          child: const Text(
                            "  User  ",
                            style: TextStyle(color: blackColor, fontSize: 12),
                          ),
                        ),
                      ]))
                ]),
          ]),
          if (discoverCubit.state.status == DiscoverStatus.success) ...[
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: RefreshIndicator(
                  onRefresh: () async {
                    discoverCubit.state.searchTerm == ''
                        ? discoverCubit.getRecomendationData(SearchFilterEntity(
                            categoryInput: discoverCubit.state.categoryInput,
                            commitmentInput:
                                discoverCubit.state.commitmentInput,
                            interestInput:
                                discoverCubit.state.interestInput.value))
                        : discoverCubit.getData(
                            discoverCubit.state.searchTerm,
                            SearchFilterEntity(
                                categoryInput:
                                    discoverCubit.state.categoryInput,
                                commitmentInput:
                                    discoverCubit.state.commitmentInput,
                                interestInput:
                                    discoverCubit.state.interestInput.value));
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          discoverCubit.state.searchTerm == ''
                              ? Column(children: [
                                  Center(
                                      child: subHeaderText('Our Picks For You',
                                          color: greyColor, size: 18.0)),
                                  const SizedBox(height: 10),
                                ])
                              : const SizedBox(),
                          for (int i = 0;
                              i < discoverCubit.state.externalTeamData.length;
                              i++) ...[
                            GestureDetector(
                              onTap: () {
                                searchFocusNode.unfocus();
                                navigatePushWithData(
                                    context, "/discover/external_teams", [
                                  discoverCubit.state.externalTeamData[i].id,
                                  discoverCubit.state.userId
                                ]);
                              },
                              child: SearchTeamCard(
                                  data:
                                      discoverCubit.state.externalTeamData[i]),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ]),
                  )),
            ))
          ] else ...[
            const Center(child: CircularProgressIndicator())
          ]
        ]),
      );
    });
  }

  void searchFilter(DiscoverCubit cubit, SearchFilterEntity filter) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        context: context,
        builder: (context) {
          return SearchFilterBox(filterData: filter);
        }).then((value) {
      if (value != null) {
        cubit.onFilterApply(value);
        cubit.state.searchTerm == ''
            ? cubit.getRecomendationData(SearchFilterEntity(
                categoryInput: discoverCubit.state.categoryInput,
                commitmentInput: discoverCubit.state.commitmentInput,
                interestInput: discoverCubit.state.interestInput.value))
            : cubit.getData(
                cubit.state.searchTerm,
                SearchFilterEntity(
                    categoryInput: discoverCubit.state.categoryInput,
                    commitmentInput: discoverCubit.state.commitmentInput,
                    interestInput: discoverCubit.state.interestInput.value));
      }
    });
  }
}
