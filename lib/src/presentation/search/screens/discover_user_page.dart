import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/search/search_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/search/cubits/discover_user_cubit.dart';
import 'package:launchlab/src/presentation/search/widgets/search_user_card.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DiscoverUserPage extends StatelessWidget {
  const DiscoverUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiscoverUserCubit(
          SearchRepository(), UserRepository(Supabase.instance)),
      child: const DiscoverUserContent(),
    );
  }
}

class DiscoverUserContent extends StatefulWidget {
  const DiscoverUserContent({Key? key}) : super(key: key);

  @override
  State<DiscoverUserContent> createState() => _DiscoverUserContentState();
}

class _DiscoverUserContentState extends State<DiscoverUserContent> {
  final TextEditingController _searchController = TextEditingController();
  late DiscoverUserCubit discoverCubit;

  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    discoverCubit = BlocProvider.of<DiscoverUserCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverUserCubit, DiscoverUserState>(
        builder: (context, state) {
      final discoverCubit = BlocProvider.of<DiscoverUserCubit>(context);

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
                    headerText("Find Users"),
                  ]),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      height: 45,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(children: [
                        Flexible(
                          flex: 1,
                          child: TextField(
                            focusNode: searchFocusNode,
                            cursorColor: greyColor,
                            controller: _searchController,
                            onChanged: (value) =>
                                {discoverCubit.getSearchUserData(value)},
                            decoration: InputDecoration(
                              fillColor: whiteColor,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              hintText: 'Search Username (eg. projectrama)',
                              hintStyle: const TextStyle(
                                  color: greyColor, fontSize: 13),
                            ),
                          ),
                        ),
                        /*
                        InkWell(
                            onTap: () {
                              discoverCubit.getSearchUserData('csgod');
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
                                )))
                                */
                      ]),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: whiteColor,
                              side:
                                  const BorderSide(width: 1, color: blackColor),
                              minimumSize: const Size.fromRadius(15),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20)),
                          onPressed: () {
                            navigateGo(context, '/discover');
                          },
                          child: const Text(
                            "Team",
                            style: TextStyle(color: blackColor, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: blackColor,
                              side:
                                  const BorderSide(width: 1, color: blackColor),
                              minimumSize: const Size.fromRadius(15),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20)),
                          onPressed: () {
                            debugPrint('User');
                          },
                          child: const Text(
                            "  User  ",
                            style: TextStyle(color: whiteColor, fontSize: 12),
                          ),
                        ),
                      ]))
                ]),
          ]),
          if (discoverCubit.state.status == DiscoverUserStatus.success) ...[
            Expanded(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0;
                              i < discoverCubit.state.externalUserData.length;
                              i++) ...[
                            GestureDetector(
                              onTap: () {
                                searchFocusNode.unfocus();
                                Supabase.instance.client.auth.currentUser!.id ==
                                        discoverCubit
                                            .state.externalUserData[i].id
                                    ? navigateGo(context, '/profile')
                                    : context.push(
                                        "/profile/${discoverCubit.state.externalUserData[i].id}");
                              },
                              child: SearchUserCard(
                                  userData:
                                      discoverCubit.state.externalUserData[i]),
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
    });
  }
}
