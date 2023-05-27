import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prototype/src/presentation/chat/screens/chat_page.dart';
import 'package:prototype/src/presentation/common/screens/protected_screen_page.dart';
import 'package:prototype/src/presentation/common/screens/splash_screen_page.dart';
import 'package:prototype/src/presentation/user/screens/profile_page.dart';
import '../presentation/authentication/screens/signin_page.dart';
import '../presentation/common/screens/unprotected_screen_page.dart';
import '../presentation/common/widgets/scaffold_with_bottom_nav.dart';
import '../presentation/team/screens/discover_page.dart';
import '../presentation/team/screens/team_home_page.dart';

/// A file to configure the routing of the application

// private navigator keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _protectedShellNavigatorKey = GlobalKey<NavigatorState>();
final _unprotectedShellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  initialLocation: "/",
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const SplashScreenPage(),
    ),
    ShellRoute(
      navigatorKey: _unprotectedShellNavigatorKey,
      builder: (context, state, child) {
        return UnprotectedScreenPage(child: child);
      },
      routes: [
        GoRoute(
          path: "/signin",
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SigninPage()),
        ),
      ],
    ),
    ShellRoute(
      navigatorKey: _protectedShellNavigatorKey,
      builder: (context, state, child) {
        return ProtectedScreenPage(
          child: ScaffoldWithBottomNav(
            child: child,
          ),
        );
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
