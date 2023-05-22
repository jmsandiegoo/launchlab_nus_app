import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prototype/src/features/authentication/presentation/pages/login_page.dart';
import 'package:prototype/src/features/chat/presentation/chat_page.dart';
import 'package:prototype/src/features/team/presentation/pages/discover_page.dart';
import 'package:prototype/src/features/team/presentation/pages/team_home_page.dart';
import 'package:prototype/src/features/user/presentation/page/profile_page.dart';
import '../features/authentication/presentation/pages/sign_up_page.dart';
import '../shared/widgets/scaffold_with_bottom_nav.dart';

/// A file to configure the routing of the application

// private navigator keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  initialLocation: "/",
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: "/signup",
      builder: (context, state) => const SignUpPage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithBottomNav(child: child);
      },
      routes: [
        GoRoute(
          path: "/team-home",
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: TeamHomePage()),
        ),
        GoRoute(
          path: "/chats",
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ChatPage()),
        ),
        GoRoute(
          path: "/discover",
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: RocketPage()),
        ),
        GoRoute(
          path: "/profile",
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProfilePage()),
        )
      ],
    )
  ],
);
