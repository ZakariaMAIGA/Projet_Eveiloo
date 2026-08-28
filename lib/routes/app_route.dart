abstract final class AppRoutes {
  static const onboarding = '/onboarding';
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const overview = '/overview';
  static const childActivities = '/child/activities';
  static const childActivityDetail = '/child/activities/:activityId';
  static const childActivityPlay = '/child/activities/:activityId/play';
  static const childActivityResult = '/child/activities/:activityId/result';
  static const adminActivities = '/admin/activities';
  static const adminAddActivity = '/admin/activities/add';
  static const adminEditActivity = '/admin/activities/:activityId/edit';
  static const adminQuestions = '/admin/activities/:activityId/questions';
  static const adminAddQuestion = '/admin/activities/:activityId/questions/add';
  static const adminEditQuestion =
      '/admin/activities/:activityId/questions/:questionId/edit';

  static const loginName = 'login';
  static const onboardingName = 'onboarding';
  static const splashName = 'splash';
  static const registerName = 'register';
  static const homeName = 'home';
  static const overviewName = 'overview';
  static const childActivitiesName = 'child-activities';
  static const childActivityDetailName = 'child-activity-detail';
  static const childActivityPlayName = 'child-activity-play';
  static const childActivityResultName = 'child-activity-result';
  static const adminActivitiesName = 'admin-activities';
  static const adminAddActivityName = 'admin-add-activity';
  static const adminEditActivityName = 'admin-edit-activity';
  static const adminQuestionsName = 'admin-questions';
  static const adminAddQuestionName = 'admin-add-question';
  static const adminEditQuestionName = 'admin-edit-question';
}
