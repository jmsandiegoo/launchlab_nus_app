import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/search/search_repository.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/search/search_filter_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/search/cubits/discover_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/commitment_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../common/widgets/form_fields/dropwdown_search_field.dart';

class SearchFilterBox extends StatelessWidget {
  final SearchFilterEntity filterData;

  const SearchFilterBox({super.key, required this.filterData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiscoverCubit(
          CommonRepository(Supabase.instance), SearchRepository()),
      child: SearchFilterContent(filterData: filterData),
    );
  }
}

class SearchFilterContent extends StatefulWidget {
  final SearchFilterEntity filterData;
  const SearchFilterContent({super.key, required this.filterData});

  @override
  State<SearchFilterContent> createState() => _SearchFilterContentState();
}

class _SearchFilterContentState extends State<SearchFilterContent> {
  final _categories = [
    "",
    "School",
    "Personal",
    "Competition",
    "Startup / Company",
    "Volunteer Work",
    "Others"
  ];

  @override
  void initState() {
    super.initState();
    final discoverCubit = BlocProvider.of<DiscoverCubit>(context);
    discoverCubit.onFilterApply(widget.filterData);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(builder: (context, state) {
      final discoverCubit = BlocProvider.of<DiscoverCubit>(context);
      return SizedBox(
        height: 1000,
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: subHeaderText("Filter")),
              GestureDetector(
                  onTap: () {
                    discoverCubit.clearAll();
                  },
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Clear All",
                            style:
                                TextStyle(decoration: TextDecoration.underline))
                      ])),
              const SizedBox(height: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("Category",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: blackColor)),
                const SizedBox(height: 5),
                SizedBox(
                  height: 50.0,
                  child: DropdownButtonFormField(
                    isDense: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 14),
                      fillColor: whiteColor,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightGreyColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightGreyColor, width: 1),
                      ),
                    ),
                    isExpanded: true,
                    value: discoverCubit.state.categoryInput,
                    style: const TextStyle(color: blackColor, fontSize: 15),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: _categories.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      discoverCubit.onCategoryChanged(newValue!);
                    },
                  ),
                ),
              ]),
              const SizedBox(height: 15),
              subHeaderText("Commitment Level", size: 15.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                CommitmentButton(
                    text: "    Low    ", newLevel: 'Low', cubit: discoverCubit),
                CommitmentButton(
                    text: "  Medium  ",
                    newLevel: 'Medium',
                    cubit: discoverCubit),
                CommitmentButton(
                    text: "    High    ",
                    newLevel: 'High',
                    cubit: discoverCubit),
              ]),
              const SizedBox(height: 15),
              const Text("Interest Areas",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: blackColor)),
              const SizedBox(height: 5),
              DropdownSearchFieldMultiWidget<SkillEntity>(
                focusNode: FocusNode(),
                label: "",
                getItems: (String filter) async {
                  await discoverCubit.handleGetSkillsInterests(filter);
                  return discoverCubit.state.skillInterestOptions;
                },
                selectedItems: discoverCubit.state.interestInput.value,
                isChipsOutside: true,
                isFilterOnline: true,
                onChangedHandler: (values) {
                  discoverCubit.onInterestChanged(values);
                },
                compareFnHandler: (p0, p1) => p0.emsiId == p1.emsiId,
              ),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  child: bodyText("  Apply  "),
                  onPressed: () {
                    Navigator.of(context).pop(SearchFilterEntity(
                        categoryInput: discoverCubit.state.categoryInput,
                        commitmentInput: discoverCubit.state.commitmentInput,
                        interestInput:
                            discoverCubit.state.interestInput.value));
                  },
                ),
              ),
            ]),
          ),
        ]),
      );
    });
  }
}
