import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/presentation/authentication/screens/signin_page.dart';
import 'package:launchlab/src/presentation/chat/screens/chat_page.dart';
import 'package:launchlab/src/presentation/common/screens/protected_screen_page.dart';
import 'package:launchlab/src/presentation/common/screens/splash_screen_page.dart';
import 'package:launchlab/src/presentation/common/screens/unprotected_screen_page.dart';
import 'package:launchlab/src/presentation/common/widgets/scaffold_with_bottom_nav.dart';
import 'package:launchlab/src/presentation/search/screens/discover_page.dart';
import 'package:launchlab/src/presentation/team/screens/team_home_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_add_accomplishment_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_add_experience_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_edit_accomplishment_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_edit_experience_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_finish_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_step1_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_step2_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_step3_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_step4_page.dart';
import 'package:launchlab/src/presentation/user/screens/onboarding_welcome_page.dart';
import 'package:launchlab/src/presentation/user/screens/profile_add_experience_page.dart';
import 'package:launchlab/src/presentation/user/screens/profile_edit_about_page.dart';
import 'package:launchlab/src/presentation/user/screens/profile_edit_experience_page.dart';
import 'package:launchlab/src/presentation/user/screens/profile_edit_intro_page.dart';
import 'package:launchlab/src/presentation/user/screens/profile_edit_skills_page.dart';
import 'package:launchlab/src/presentation/user/screens/profile_manage_experience_page.dart';
import 'package:launchlab/src/presentation/user/screens/profile_page.dart';
import 'package:launchlab/src/presentation/user/widgets/intro_form.dart';
import 'package:launchlab/src/presentation/user/widgets/onboarding_container.dart';
import 'package:launchlab/src/presentation/user/widgets/onboarding_steps_layout.dart';
import 'package:launchlab/src/presentation/team/screens/create_team_page.dart';
import 'package:launchlab/src/presentation/team/screens/edit_team_page.dart';
import 'package:launchlab/src/presentation/search/screens/external_team_page.dart';
import 'package:launchlab/src/presentation/team/screens/team_page.dart';
import 'package:launchlab/src/presentation/user/widgets/profile_experience_list.dart';

/// A file to configure the routing of the application

// private navigator keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _protectedShellNavigatorKey = GlobalKey<NavigatorState>();
final _unprotectedShellNavigatorKey = GlobalKey<NavigatorState>();

final _mainShellKey = GlobalKey<NavigatorState>();
final _onboardingShellKey = GlobalKey<NavigatorState>();
final _nestedOnboardingShellKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: "/",
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/',
      builder: (context, state) {
        return const SplashScreenPage();
      },
    ),
    ShellRoute(
      navigatorKey: _unprotectedShellNavigatorKey,
      builder: (context, state, child) {
        return UnprotectedScreenPage(child: child);
      },
      routes: [
        GoRoute(
          parentNavigatorKey: _unprotectedShellNavigatorKey,
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
              parentNavigatorKey: _onboardingShellKey,
              path: "/onboard",
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: OnboardingWelcomePage(),
                );
              },
            ),
            ShellRoute(
              navigatorKey: _nestedOnboardingShellKey,
              builder: (context, state, child) =>
                  OnboardingStepsLayout(child: child),
              routes: [
                GoRoute(
                  path: "/onboard/step-1",
                  builder: (context, state) {
                    return const OnboardingStep1Page();
                  },
                ),
                GoRoute(
                  path: "/onboard/step-2",
                  builder: (context, state) {
                    return const OnboardingStep2Page();
                  },
                ),
                GoRoute(
                  parentNavigatorKey: _nestedOnboardingShellKey,
                  path: "/onboard/step-3",
                  builder: (context, state) {
                    return const OnboardingStep3Page();
                  },
                ),
                GoRoute(
                  path: "/onboard/step-4",
                  builder: (context, state) {
                    return const OnboardingStep4Page();
                  },
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: _onboardingShellKey,
              path: "/onboard-success",
              builder: (context, state) => const OnboardingFinishPage(),
            ),
            GoRoute(
              parentNavigatorKey: _onboardingShellKey,
              path: "/onboard-add-experience",
              builder: (context, state) => const OnboardingAddExperiencePage(),
            ),
            GoRoute(
              parentNavigatorKey: _onboardingShellKey,
              path: "/onboard-edit-experience",
              builder: (context, state) => OnboardingEditExperiencePage(
                experience: state.extra as ExperienceEntity,
              ),
            ),
            GoRoute(
              parentNavigatorKey: _onboardingShellKey,
              path: "/onboard-add-accomplishment",
              builder: (context, state) =>
                  const OnboardingAddAccomplishmentPage(),
            ),
            GoRoute(
              parentNavigatorKey: _onboardingShellKey,
              path: "/onboard-edit-accomplishment",
              builder: (context, state) => OnboardingEditAccomplishmentPage(
                accomplishment: state.extra as AccomplishmentEntity,
              ),
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
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: TeamHomePage());
                }),
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
              parentNavigatorKey: _mainShellKey,
              path: "/profile",
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfilePage()),
              routes: [
                GoRoute(
                  path: "edit-intro",
                  builder: (context, state) => ProfileEditIntroPage(
                    props: state.extra as ProfileEditIntroPageProps,
                  ),
                ),
                GoRoute(
                  path: "edit-about",
                  builder: (context, state) => ProfileEditAboutPage(
                    props: state.extra as ProfileEditAboutPageProps,
                  ),
                ),
                GoRoute(
                    parentNavigatorKey: _mainShellKey,
                    path: "manage-experience",
                    builder: (context, state) => ProfileManageExperiencePage(
                          props:
                              state.extra as ProfileManageExperiencePageProps,
                        ),
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _mainShellKey,
                        path: "add-experience",
                        builder: (context, state) =>
                            const ProfileAddExperiencePage(),
                      ),
                      GoRoute(
                        parentNavigatorKey: _mainShellKey,
                        path: "edit-experience",
                        builder: (context, state) => ProfileEditExperiencePage(
                          experience: state.extra as ExperienceEntity,
                        ),
                      ),
                    ]),
                GoRoute(
                  path: "edit-skills",
                  builder: (context, state) => ProfileEditSkillsPage(
                    props: state.extra as ProfileEditSkillsPageProps,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "/teams",
              builder: (context, state) => TeamPage(state.extra as List),
            ),
            GoRoute(
              path: "/create_teams",
              pageBuilder: (context, state) => NoTransitionPage(
                  child: CreateTeamPage(userId: state.extra as String)),
            ),
            GoRoute(
              path: "/edit_teams",
              pageBuilder: (context, state) => NoTransitionPage(
                  child: EditTeamPage(teamId: state.extra as String)),
            ),
            GoRoute(
              path: "/external_teams",
              pageBuilder: (context, state) => NoTransitionPage(
                  child:
                      ExternalTeamPage(teamIdUserIdData: state.extra as List)),
            ),
          ],
        ),
      ],
    ),
  ],
);
