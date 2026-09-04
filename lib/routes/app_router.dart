// routes/app_router.dart
import 'package:eveiloo_enfant/features/Nootifications/notification.dart';
import 'package:eveiloo_enfant/features/activities/activitiesRoutes.dart';
import 'package:eveiloo_enfant/features/auth/AuthGate.dart';
import 'package:eveiloo_enfant/features/auth/forgot_password_page.dart';
import 'package:eveiloo_enfant/features/auth/register_page.dart';
import 'package:eveiloo_enfant/features/auth/splash_page.dart';
import 'package:eveiloo_enfant/features/cart/cart_page.dart';
import 'package:eveiloo_enfant/features/catalogues/catalogueRoutes.dart';
import 'package:eveiloo_enfant/features/checkout/checkout_page.dart';
import 'package:eveiloo_enfant/features/children/children_routes.dart';
import 'package:eveiloo_enfant/features/onboarding/onboarding_page.dart';
import 'package:eveiloo_enfant/widgets/CommandeDetails.dart';
import 'package:eveiloo_enfant/features/commandes/mes_Commandes_page.dart';
import 'package:eveiloo_enfant/features/parametre/parametre.dart';
import 'package:eveiloo_enfant/features/profil/profileRoutes.dart';
import 'package:eveiloo_enfant/features/progression/progression.dart';
import 'package:eveiloo_enfant/features/toys/admin_toys_page.dart';
import 'package:eveiloo_enfant/features/tutorials/tutorialsRoutes.dart';
import 'package:eveiloo_enfant/models/cart_model.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:eveiloo_enfant/features/favoris/favoris.dart';
import 'package:eveiloo_enfant/features/home/homeRoutes.dart';
import 'package:eveiloo_enfant/features/auth/login_page.dart';
import 'package:eveiloo_enfant/features/overview/overview_page.dart';
import 'package:eveiloo_enfant/routes/child_shell_routes.dart';
import 'package:eveiloo_enfant/widgets/app_bottom_navigation.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    // Point d’entrée principal : AuthGate décidera login vs home
    initialLocation: '/',
    routes: [
      // ---------- Route racine avec AuthGate ----------
      GoRoute(
        path: '/',
        // pas de name obligatoire, mais tu peux en mettre un si tu veux
        name: 'root',
        builder: (context, state) => const AuthGate(),
      ),

      // ---------- Auth & Overview ----------
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
        builder: (context, state) => const SplashPage(),
      ),

      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboardingName,
        builder: (context, state) => const OnboardingPage(),
      ),

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

      GoRoute(
        path: AppRoutes.forgotPassword,
        name: AppRoutes.forgotPasswordName,
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // ---------- Navigation principale (tabs) ----------
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

      // ---------- Shell ENFANT (hors shell parent) ----------
      childShellRoute,

      // ---------- Routes “enfants” (hors shell) ----------
      ...childrenRoutes,

      // ---------- Notifications ----------
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: AppRoutes.favoris, // ex: '/favoris/:enfantId'
        name: AppRoutes.favorisName,
        builder: (context, state) {
          final enfantId = state.pathParameters['enfantId'] ?? '';

          return Favoris(
            enfantId: enfantId,
          );
        },
      ),
      // Route Administration ajoutée
      GoRoute(
        path: AppRoutes.parametre,
        name: AppRoutes.parametreName,
        builder: (context, state) => const ParametresPage(),
      ),

      // ---------- Admin ----------
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

      GoRoute(
        path: AppRoutes.cart,
        name: AppRoutes.cartName,
        builder: (context, state) => const CartPage(),
      ),

      GoRoute(
        path: AppRoutes.progression,
        name: AppRoutes.progressionName,
        builder: (context, state) {
          final enfantId = state.pathParameters['enfantId']!;
          return ProgressionPage(enfantId: enfantId);
        },
      ),

      GoRoute(
        path: AppRoutes.checkout,
        name: AppRoutes.checkoutName,
        builder: (context, state) {
          final articles = state.extra as List<CartItemModel>;
          return CheckoutPage(articles: articles);
        },
      ),

      GoRoute(
        path: AppRoutes.commandes,
        name: AppRoutes.commandesName,
        builder: (context, state) => const MesCommandesPage(),
      ),

      GoRoute(
        path: AppRoutes.commandeDetail,
        name: AppRoutes.commandeDetailName,
        builder: (context, state) {
          final commandeId = state.pathParameters['commandeId']!;
          return CommandeDetailPage(commandeId: commandeId);
        },
      ),
    ],
  );
}
