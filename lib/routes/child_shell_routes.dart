import 'package:eveiloo_enfant/features/activities/activities_page.dart';
import 'package:eveiloo_enfant/features/activities/child/activity_detail_page.dart';
import 'package:eveiloo_enfant/features/activities/child/activity_play_page.dart';
import 'package:eveiloo_enfant/features/activities/child/activity_result_page.dart';
import 'package:eveiloo_enfant/features/children/children_profil.dart';
import 'package:eveiloo_enfant/features/tutorials/tutorial_detail_page.dart';
import 'package:eveiloo_enfant/features/tutorials/tutorial_page.dart';
import 'package:eveiloo_enfant/models/TutorielModel.dart';
import 'package:eveiloo_enfant/models/activity_model.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:eveiloo_enfant/widgets/child_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/provider/enfant_selectionne_provider.dart';

final StatefulShellRoute childShellRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) =>
      ChildBottomNavigation(navigationShell: navigationShell),
  branches: [
    // Branche 1 : Accueil (dashboard enfant)
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.childHome, // '/child/home'
          name: AppRoutes.childHomeName,
          builder: (context, state) => _AvecEnfantSelectionne(
            builder: (enfantId) => ChildrenProfil(enfantId: enfantId),
          ),
        ),
      ],
    ),

    // Branche 2 : Activités
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.childActivities, // '/child/activities'
          name: AppRoutes.childActivitiesName,
          builder: (context, state) => _AvecEnfantSelectionne(
            builder: (enfantId) => ActivitiesPage(enfantId: enfantId),
          ),
          routes: [
            GoRoute(
              path: 'detail',
              name: AppRoutes.childActivityDetailName,
              builder: (context, state) {
                final params =
                    state.extra! as ({ActivityModel activity, String enfantId});
                return ActivityDetailPage(
                  activity: params.activity,
                  enfantId: params.enfantId,
                );
              },
            ),
            GoRoute(
              path: 'play',
              name: AppRoutes.childActivityPlayName,
              builder: (context, state) {
                final params =
                    state.extra! as ({ActivityModel activity, String enfantId});
                return ActivityPlayPage(
                  activity: params.activity,
                  enfantId: params.enfantId,
                );
              },
            ),
            GoRoute(
              path: 'result',
              name: AppRoutes.childActivityResultName,
              builder: (context, state) {
                final result =
                    state.extra!
                        as ({
                          ActivityModel activity,
                          int score,
                          int totalQuestions,
                        });
                return ActivityResultPage(
                  activity: result.activity,
                  score: result.score,
                  totalQuestions: result.totalQuestions,
                );
              },
            ),
          ],
        ),
      ],
    ),

    // Branche 3 : Tutoriels
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.childTutorials,
          name: AppRoutes.childTutorialsName,
          builder: (context, state) => _AvecEnfantSelectionne(
            builder: (enfantId) => TutorialsPage(enfantId: enfantId),
          ),
          routes: [
            GoRoute(
              path: 'detail',
              name: AppRoutes.childTutorialDetailName,
              builder: (context, state) {
                final params =
                    state.extra as ({TutorielModel tutoriel, String enfantId});
                return TutorialDetailPage(
                  tutoriel: params.tutoriel,
                  enfantId: params.enfantId,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Petit wrapper qui lit l'enfant sélectionné et affiche un écran de secours
/// si jamais on arrive sur ces routes sans être passé par MesEnfantsPage
/// (deep link direct, retour arrière inattendu, etc.)
class _AvecEnfantSelectionne extends ConsumerWidget {
  final Widget Function(String enfantId) builder;

  const _AvecEnfantSelectionne({required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enfantId = ref.watch(enfantSelectionneProvider);
    if (enfantId == null) {
      // Filet de sécurité : redirige vers la liste des enfants.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GoRouter.of(context).goNamed(AppRoutes.childrenListName);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return builder(enfantId);
  }
}
