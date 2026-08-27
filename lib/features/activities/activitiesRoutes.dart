import 'package:eveiloo_enfant/features/activities/activities_page.dart';
import 'package:eveiloo_enfant/features/activities/child/activity_detail_page.dart';
import 'package:eveiloo_enfant/features/activities/child/activity_play_page.dart';
import 'package:eveiloo_enfant/features/activities/child/activity_result_page.dart';
import 'package:eveiloo_enfant/models/activity_model.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> activitiesRoutes = [
  GoRoute(
    path: AppRoutes.activities,
    name: AppRoutes.activitiesName,
    builder: (context, state) => const ActivitiesPage(),
  ),

  //  GoRoute(
  //   path: AppRoutes.childActivities,
  //   name: AppRoutes.childActivitiesName,
  //   builder: (context, state) => const ActivitiesPage(),
  // ),
  GoRoute(
    path: AppRoutes.childActivityDetail,
    name: AppRoutes.childActivityDetailName,
    builder: (context, state) =>
        ActivityDetailPage(activity: state.extra! as ActivityModel),
  ),
  GoRoute(
    path: AppRoutes.childActivityPlay,
    name: AppRoutes.childActivityPlayName,
    builder: (context, state) =>
        ActivityPlayPage(activity: state.extra! as ActivityModel),
  ),
  GoRoute(
    path: AppRoutes.childActivityResult,
    name: AppRoutes.childActivityResultName,
    builder: (context, state) {
      final result =
          state.extra!
              as ({ActivityModel activity, int score, int totalQuestions});
      return ActivityResultPage(
        activity: result.activity,
        score: result.score,
        totalQuestions: result.totalQuestions,
      );
    },
  ),
];
