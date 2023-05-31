import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:launchlab/src/presentation/authentication/screens/signin_page.dart';
import 'package:launchlab/src/presentation/chat/screens/chat_page.dart';
import 'package:launchlab/src/presentation/common/screens/protected_screen_page.dart';
import 'package:launchlab/src/presentation/common/screens/splash_screen_page.dart';
import 'package:launchlab/src/presentation/common/screens/unprotected_screen_page.dart';
import 'package:launchlab/src/presentation/common/widgets/scaffold_with_bottom_nav.dart';
import 'package:launchlab/src/presentation/team/screens/discover_page.dart';
import 'package:launchlab/src/presentation/team/screens/team_home_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_finish_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_step1_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_step2_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_step3_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_welcome_page.dart';
import 'package:launchlab/src/presentation/user/screens/profile_page.dart';
import 'package:launchlab/src/presentation/user/widgets/onboarding_container.dart';

/// A file to configure the routing of the application

// private navigator keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _protectedShellNavigatorKey = GlobalKey<NavigatorState>();
final _unprotectedShellNavigatorKey = GlobalKey<NavigatorState>();

final _mainShellKey = GlobalKey<NavigatorState>();
final _onboardingShellKey = GlobalKey<NavigatorState>();
final _nestedOnboardingShellKey = GlobalKey<NavigatorState>();

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
        return ProtectedScreenPage(child: child);
      },
      routes: [
        ShellRoute(
          navigatorKey: _onboardingShellKey,
          builder: (context, state, child) => OnboardingContainer(child: child),
          routes: [
            GoRoute(
              path: "/onboard",
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: OnboardingWelcomePage(),
                );
              },
              routes: [
                ShellRoute(
                  navigatorKey: _nestedOnboardingShellKey,
                  builder: (context, state, child) => child,
                  routes: [
                    GoRoute(
                      path: "step-1",
                      builder: (context, state) {
                        return const OnboardingStep1Page();
                      },
                    ),
                    GoRoute(
                      path: "step-2",
                      builder: (context, state) {
                        return const OnboardingStep2Page();
                      },
                    ),
                    GoRoute(
                      path: "step-3",
                      builder: (context, state) {
                        return const OnboardingStep3Page();
                      },
                    ),
                    GoRoute(
                      path: "step-4",
                      builder: (context, state) {
                        return const OnboardingStep1Page();
                      },
                    )
                  ],
                ),
              ],
            ),
            GoRoute(
              path: "/onboard-success",
              builder: (context, state) => const OnboardingFinishPage(),
            ),
          ],
        ),
        ShellRoute(
          navigatorKey: _mainShellKey,
          builder: (context, state, child) =>
              ScaffoldWithBottomNav(child: child),
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
                  const NoTransitionPage(child: DiscoverPage()),
            ),
            GoRoute(
              path: "/profile",
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfilePage()),
            )
          ],
        )
      ],
    )
  ],
);
