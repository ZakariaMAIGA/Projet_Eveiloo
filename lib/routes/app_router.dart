import 'package:eveiloo_enfant/features/articles/activite_page.dart';
import 'package:eveiloo_enfant/features/Nootifications/notification.dart';
import 'package:eveiloo_enfant/features/auth/register_page.dart';
import 'package:eveiloo_enfant/features/catalogues/catalogue.dart';
import 'package:eveiloo_enfant/features/profil/profil_page.dart';
import 'package:eveiloo_enfant/features/tutorials/tutorial_page.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:eveiloo_enfant/features/home/home_page.dart';
import 'package:eveiloo_enfant/features/auth/login_page.dart';
import 'package:eveiloo_enfant/features/favoris/favoris.dart';
import 'package:eveiloo_enfant/features/overview/overview_page.dart';
import 'package:eveiloo_enfant/widgets/app_bottom_navigation.dart';
import 'package:go_router/go_router.dart';


class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.overview,
    routes: [
      GoRoute(
        path: AppRoutes.overview,
        name: AppRoutes.overviewName,
        builder: (context, state) => const OverviewPage(),
      ),

      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.registerName,
        builder: (context, state) => const RegisterPage(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppBottomNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: AppRoutes.homeName,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tutorials,
                name: AppRoutes.tutorialsName,
                builder: (context, state) => const TutorialPage(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.catalogue,
                name: AppRoutes.catalogueName,
                builder: (context, state) => const Catalogue(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.activities,
                name: AppRoutes.activitiesName,
                builder: (context, state) => const ActivitePage(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: AppRoutes.profileName,
                builder: (context, state) => const ProfilPage(),
              ),
            ],
          ),
        ],
      ),
      
      GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsPage(),
    ),
      GoRoute(
      path: '/favoris',
      builder: (context, state) => const FavorisScreen(
        enfantId: "403ZaeYfDCM3DVHVsxSV",
      ),
    ),
    ],
  );
}
