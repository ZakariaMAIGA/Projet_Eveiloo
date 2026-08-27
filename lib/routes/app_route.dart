abstract final class AppRoutes {
  //routes overview
  static const overview = '/overview';

  //routes login and register
  static const login = '/login';
  static const register = '/register';

  //routes main tabs
  static const home = '/home';
  static const activities = '/activities';
  static const tutorials = '/tutorials';
  static const profile = '/profile';
  static const catalogue = '/catalogue';

  // activites and sous routes
  static const childActivities = '/child/activities';
  static const childActivityDetail = '/child/activities/:activityId';
  static const childActivityPlay = '/child/activities/:activityId/play';
  static const childActivityResult = '/child/activities/:activityId/result';

  // Sous-routes du catalogue (imbriquées, relatives à /catalogue)
  static const categories = 'categories'; // -> /catalogue/categories
  static const toys = 'toys'; // -> /catalogue/toys
  static const toyDetail = ':toyId'; // -> /catalogue/toys/:toyId

  // route liste complète des enfants (hors shell, poussée depuis le home)
  static const childrenList = '/children';

  // routes admin
  static const String adminToys = '/admin-toys';
  static const adminActivities = '/admin/activities';
  static const adminAddActivity = '/admin/activities/add';
  static const adminEditActivity = '/admin/activities/:activityId/edit';
  static const adminQuestions = '/admin/activities/:activityId/questions';
  static const adminAddQuestion = '/admin/activities/:activityId/questions/add';
  static const adminEditQuestion =
      '/admin/activities/:activityId/questions/:questionId/edit';

  //routes names

  static const overviewName = 'overview';

  static const loginName = 'login';
  static const registerName = 'register';

  static const homeName = 'home';
  static const activitiesName = 'activities';
  static const tutorialsName = 'tutorials';
  static const profileName = 'profile';
  static const catalogueName = 'catalogue';

  static const categoriesName = 'categories';
  static const toysName = 'toys';
  static const toyDetailName = 'toy-detail';

  static const childrenListName = 'children';

  //activites
  static const childActivitiesName = 'child-activities';
  static const childActivityDetailName = 'child-activity-detail';
  static const childActivityPlayName = 'child-activity-play';
  static const childActivityResultName = 'child-activity-result';

  // routes name admin
  static const String adminToysName = 'adminToys';
  static const adminActivitiesName = 'admin-activities';
  static const adminAddActivityName = 'admin-add-activity';
  static const adminEditActivityName = 'admin-edit-activity';
  static const adminQuestionsName = 'admin-questions';
  static const adminAddQuestionName = 'admin-add-question';
  static const adminEditQuestionName = 'admin-edit-question';
}
