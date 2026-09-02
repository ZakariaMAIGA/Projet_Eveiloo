import 'package:eveiloo_enfant/features/auth/splash_page.dart';
import 'package:eveiloo_enfant/features/onboarding/onboarding_page.dart';
import 'package:eveiloo_enfant/features/auth/register_page.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:eveiloo_enfant/features/home/home_page.dart';
import 'package:eveiloo_enfant/features/auth/login_page.dart';
import 'package:eveiloo_enfant/features/overview/overview_page.dart';
import 'package:eveiloo_enfant/features/activities/activities_page.dart';
import 'package:eveiloo_enfant/features/activities/admin/activities_admin_page.dart';
import 'package:eveiloo_enfant/features/activities/admin/add_activity_page.dart';
import 'package:eveiloo_enfant/features/activities/admin/add_question_page.dart';
import 'package:eveiloo_enfant/features/activities/admin/edit_activity_page.dart';
import 'package:eveiloo_enfant/features/activities/admin/edit_question_page.dart';
import 'package:eveiloo_enfant/features/activities/admin/questions_admin_page.dart';
import 'package:eveiloo_enfant/features/activities/child/activity_detail_page.dart';
import 'package:eveiloo_enfant/features/activities/child/activity_play_page.dart';
import 'package:eveiloo_enfant/features/activities/child/activity_result_page.dart';
import 'package:eveiloo_enfant/models/activity_model.dart';
import 'package:eveiloo_enfant/models/question_model.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    // Point de démarrage temporaire (mode test) : création d'activité côté
    // admin. Le bouton "Mode enfant" (icône enfant) de l'appBar permet de
    // basculer vers le côté enfant, et l'icône admin de la liste enfant
    // permet de revenir ici.
    // Remettre AppRoutes.splash pour la version normale.
    initialLocation: AppRoutes.adminAddActivity,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboardingName,
        builder: (context, state) => const OnboardingPage(),
      ),

      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
        builder: (context, state) => const SplashPage(),
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
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) => const HomePage(),
      ),

      GoRoute(
        path: AppRoutes.overview,
        name: AppRoutes.overviewName,
        builder: (context, state) => const OverviewPage(),
      ),
      GoRoute(
        path: AppRoutes.childActivities,
        name: AppRoutes.childActivitiesName,
        builder: (context, state) => const ActivitiesPage(),
      ),
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
      GoRoute(
        path: AppRoutes.adminActivities,
        name: AppRoutes.adminActivitiesName,
        builder: (context, state) => const ActivitiesAdminPage(),
      ),
      GoRoute(
        path: AppRoutes.adminAddActivity,
        name: AppRoutes.adminAddActivityName,
        builder: (context, state) => const AddActivityPage(),
      ),
      GoRoute(
        path: AppRoutes.adminEditActivity,
        name: AppRoutes.adminEditActivityName,
        builder: (context, state) =>
            EditActivityPage(activity: state.extra! as ActivityModel),
      ),
      GoRoute(
        path: AppRoutes.adminQuestions,
        name: AppRoutes.adminQuestionsName,
        builder: (context, state) =>
            QuestionsAdminPage(activity: state.extra! as ActivityModel),
      ),
      GoRoute(
        path: AppRoutes.adminAddQuestion,
        name: AppRoutes.adminAddQuestionName,
        builder: (context, state) =>
            AddQuestionPage(activityId: state.pathParameters['activityId']!),
      ),
      GoRoute(
        path: AppRoutes.adminEditQuestion,
        name: AppRoutes.adminEditQuestionName,
        builder: (context, state) {
          final question = state.extra! as QuestionModel;
          return EditQuestionPage(
            activityId: state.pathParameters['activityId']!,
            question: question,
          );
        },
      ),
    ],
  );
}
