import 'package:eveiloo_enfant/features/home/home_page.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> homeRoutes = [
  GoRoute(
    path: AppRoutes.home,
    name: AppRoutes.homeName,
    builder: (context, state) => const HomePage(),
  ),
];
