import 'package:eveiloo_enfant/features/tutorials/tutorial_detail_page.dart';
import 'package:eveiloo_enfant/features/tutorials/tutorial_page.dart';
import 'package:eveiloo_enfant/models/TutorielModel.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> tutorialsRoutes = [
  GoRoute(
    path: AppRoutes.tutorials,
    name: AppRoutes.tutorialsName,
    builder: (context, state) => const TutorialsPage (enfantId: null),
    routes: [
      GoRoute(
        path: 'detail',
        name: AppRoutes.tutorialDetailName,
        builder: (context, state) {
          final tutoriel = state.extra! as TutorielModel;
          return TutorialDetailPage(tutoriel: tutoriel, enfantId: null);
        },
      ),
    ],
  ),
];
