abstract final class AppRoutes {
  // ---------- Routes principales ----------
  static const overview = '/overview';

  // Auth
  static const login = '/login';
  static const register = '/register';

  // Tabs principales
  static const home = '/home';
  static const activities = '/activities';
  static const tutorials = '/tutorials';
  static const profile = '/profile';
  static const catalogue = '/catalogue';

  // ---------- Routes “enfants” ----------
  // Liste des enfants
  static const childrenList = '/children';
  static const childrenListName = 'children-list';

  static const childrenAdd = '/children/add';
  static const childrenAddName = 'children-add';

  static const childrenDetail = '/children/:id';
  static const childrenDetailName = 'children-detail';

  // Dashboard d’un enfant (si tu veux une route “principale” par enfant)

  static const childrenProfil = '/children/:enfantId/dashboard';
  static const childrenProfilName = 'children-dashbborad';

  // ---------- Activités enfant (sous-espace par enfant) ----------
  static const childActivities = '/child/:enfantId/activities';
  static const childActivitiesName = 'child-activities';

  static const childActivityDetail = '/child/:enfantId/activities/:activityId';
  static const childActivityDetailName = 'child-activity-detail';

  static const childActivityPlay =
      '/child/:enfantId/activities/:activityId/play';
  static const childActivityPlayName = 'child-activity-play';

  static const childActivityResult =
      '/child/:enfantId/activities/:activityId/result';
  static const childActivityResultName = 'child-activity-result';

  // ---------- Catalogue ----------
  static const categories = '/catalogue/categories';
  static const categoriesName = 'categories';

  static const toys = '/catalogue/toys';
  static const toysName = 'toys';

  static const toyDetail = '/catalogue/toys/:toyId';
  static const toyDetailName = 'toy-detail';

  // ---------- Admin ----------
  static const adminToys = '/admin-toys';
  static const adminToysName = 'admin-toys';

  static const adminActivities = '/admin/activities';
  static const adminActivitiesName = 'admin-activities';

  static const adminAddActivity = '/admin/activities/add';
  static const adminAddActivityName = 'admin-add-activity';

  static const adminEditActivity = '/admin/activities/:activityId/edit';
  static const adminEditActivityName = 'admin-edit-activity';

  static const adminQuestions = '/admin/activities/:activityId/questions';
  static const adminQuestionsName = 'admin-questions';

  static const adminAddQuestion = '/admin/activities/:activityId/questions/add';
  static const adminAddQuestionName = 'admin-add-question';

  static const adminEditQuestion =
      '/admin/activities/:activityId/questions/:questionId/edit';
  static const adminEditQuestionName = 'admin-edit-question';

  // ---------- Noms des routes principales ----------
  static const overviewName = 'overview';

  static const loginName = 'login';
  static const registerName = 'register';

  static const homeName = 'home';
  static const activitiesName = 'activities';
  static const tutorialsName = 'tutorials';
  static const profileName = 'profile';
  static const catalogueName = 'catalogue';
}
