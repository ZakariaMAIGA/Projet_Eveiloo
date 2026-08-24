import 'package:eveiloo_enfant/features/auth/register_page.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:eveiloo_enfant/features/home/home_page.dart';
import 'package:eveiloo_enfant/features/auth/login_page.dart';
import 'package:eveiloo_enfant/features/overview/overview_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.overview,
    routes: [
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
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) => const HomePage(),
      ),

      GoRoute(
        path: AppRoutes.overview,
        name: AppRoutes.overviewName,
        builder: (context, state) => const OverviewPage(),
      ),
    ],
  );
}
