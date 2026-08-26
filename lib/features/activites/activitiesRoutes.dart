import 'package:eveiloo_enfant/features/activites/activite_page.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> activitiesRoutes = [
  GoRoute(
    path: AppRoutes.activities,
    name: AppRoutes.activitiesName,
    builder: (context, state) => const ActivitePage(),
  ),
];
