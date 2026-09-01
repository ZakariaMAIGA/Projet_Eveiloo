import 'package:eveiloo_enfant/features/activities/activities_page.dart';
import 'package:eveiloo_enfant/features/activities/child/activity_detail_page.dart';
import 'package:eveiloo_enfant/models/activity_model.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> activitiesRoutes = [
  GoRoute(
    path: AppRoutes.activities,
    name: AppRoutes.activitiesName,
    builder: (context, state) => const ActivitiesPage(), // enfantId null
    routes: [
      GoRoute(
        path: 'detail',
        name: AppRoutes
            .activityDetailName, // nouveau nom, distinct de childActivityDetailName
        builder: (context, state) {
          final activity = state.extra! as ActivityModel;
          return ActivityDetailPage(activity: activity, enfantId: null);
        },
      ),
    ],
  ),
];
