import 'package:eveiloo_enfant/features/Nootifications/notification.dart';
import 'package:eveiloo_enfant/features/activites/activitiesRoutes.dart';
import 'package:eveiloo_enfant/features/auth/register_page.dart';
import 'package:eveiloo_enfant/features/catalogues/catalogueRoutes.dart';
import 'package:eveiloo_enfant/features/children/children_routes.dart';
import 'package:eveiloo_enfant/features/profil/profileRoutes.dart';
import 'package:eveiloo_enfant/features/toys/admin_toys_page.dart';
import 'package:eveiloo_enfant/features/tutorials/tutorialsRoutes.dart';
import 'package:eveiloo_enfant/models/favoris.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:eveiloo_enfant/features/favoris/favoris.dart';
import 'package:eveiloo_enfant/features/home/homeRoutes.dart';
import 'package:eveiloo_enfant/features/auth/login_page.dart';
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
          StatefulShellBranch(routes: homeRoutes),
          StatefulShellBranch(routes: tutorialsRoutes),
          StatefulShellBranch(routes: catalogueRoutes),
          StatefulShellBranch(routes: activitiesRoutes),
          StatefulShellBranch(routes: profileRoutes),
        ],
      ),

      // Liste complète des enfants — poussée depuis le home,
      ...childrenRoutes,

      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: AppRoutes.favoris, // ex: '/favoris/:enfantId'
        name: AppRoutes.favorisName,
        builder: (context, state) {
          final enfantId = state.pathParameters['enfantId'] ?? '';

          return FavorisScreen(
            enfantId: enfantId,
          );
        },
      ),
      // Route Administration ajoutée
      GoRoute(
        path: AppRoutes.adminToys,
        name: AppRoutes.adminToysName,
        builder: (context, state) {
          final categorieId = state.uri.queryParameters['categorieId'];
          final categorieNom = state.uri.queryParameters['categorieNom'];
          return AdminToysPage(
            categorieId: categorieId,
            categorieNom: categorieNom,
          );
        },
      ),
    ],
  );
}
