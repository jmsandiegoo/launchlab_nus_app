import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A custom scaffold widget to work with Shell routes.
class ScaffoldWithBottomNav extends StatefulWidget {
  const ScaffoldWithBottomNav({super.key, required this.child});

  final Widget child;

  @override
  State<ScaffoldWithBottomNav> createState() => _ScaffoldWithBottomNavState();
}

class _ScaffoldWithBottomNavState extends State<ScaffoldWithBottomNav> {
  // A getter that returns a computed property index from curr location.
  int get _currentIndex => _locationToTabIndex(GoRouter.of(context).location);

  int _locationToTabIndex(String location) {
    final index =
        _tabs.indexWhere((t) => location.startsWith(t.initialLocation));
    return index < 0 ? 0 : index;
  }

  // A callback function to navigate to the desired tab
  void _onItemTapped(BuildContext context, int tabIndex) {
    if (tabIndex != _currentIndex) {
      context.go(_tabs[tabIndex].initialLocation);
    }
  }

  static final List<ScaffoldWithNavTabItem> _tabs = <ScaffoldWithNavTabItem>[
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
    const ScaffoldWithNavTabItem(
      initialLocation: "/profile",
      icon: Icon(Icons.person_outline),
      label: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _tabs,
        currentIndex: _currentIndex,
        onTap: (index) => _onItemTapped(context, index),
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
