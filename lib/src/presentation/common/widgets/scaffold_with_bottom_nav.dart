import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';

/// A custom scaffold widget to work with Shell routes.

class ScaffoldWithBottomNav extends StatelessWidget {
  const ScaffoldWithBottomNav({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithBottomNav'));

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  List<ScaffoldWithNavTabItem> _tabs(BuildContext context) =>
      <ScaffoldWithNavTabItem>[
        const ScaffoldWithNavTabItem(
          initialLocation: "/team-home",
          icon: Icon(Icons.home_outlined),
          label: "",
        ),
        const ScaffoldWithNavTabItem(
          initialLocation: "/chats",
          icon: Icon(Icons.forum_outlined),
          label: "",
        ),
        const ScaffoldWithNavTabItem(
          initialLocation: "/discover",
          icon: Icon(Icons.rocket_launch_outlined),
          label: "",
        ),
        ScaffoldWithNavTabItem(
          initialLocation:
              "/profile/${BlocProvider.of<AppRootCubit>(context).state.authUserProfile!.id}", // testing
          icon: const Icon(Icons.person_outline),
          label: "",
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(top: false, bottom: true, child: navigationShell),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _tabs(context),
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _goBranch(index),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

/// A sub widget for the tabs in the navigation bar of Scaffold.
class ScaffoldWithNavTabItem extends BottomNavigationBarItem {
  const ScaffoldWithNavTabItem(
      {required this.initialLocation, required Widget icon, String? label})
      : super(icon: icon, label: label);

  final String initialLocation;
}
