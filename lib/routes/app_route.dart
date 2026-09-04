abstract final class AppRoutes {
  // ---------- Routes principales ----------
  static const splash = '/splash';
  static const overview = '/overview';
  static const onboarding = '/onboarding';

  // Auth
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const forgotPasswordName = 'forgot-password';
  // Tabs principales
  static const home = '/home';
  static const activities = '/activities';
  static const tutorials = '/tutorials';
  static const tutorialDetail = '/tutorials/detail';
  static const tutorialDetailName = 'tutorial-detail';
  static const profile = '/profile';
  static const catalogue = '/catalogue';
  // Sous-routes du catalogue (imbriquées, relatives à /catalogue)
  static const categories = 'categories'; // -> /catalogue/categories
  static const toys = 'toys'; // -> /catalogue/toys
  static const toyDetail = ':toyId'; // -> /catalogue/toys/:toyId
  static const favoris = '/favoris';
  static const cart = '/cart';
  static const cartName = 'cart';
  static const progression = '/progression/:enfantId';
  static const progressionName = 'progression';

  // ---------- Routes d'activité ----------
  static const activityDetail = '/activities/detail';
  static const activityDetailName = 'activityDetail';

  // ---------- Routes “enfants” ----------
  // Liste des enfants
  static const childrenList = '/children';
  static const childrenListName = 'children-list';

  static const childrenAdd = '/children/add';
  static const childrenAddName = 'children-add';

  static const childrenDetail = '/children/:id';
  static const childrenDetailName = 'children-detail';

  // ---------- Shell ENFANT ----------
  static const childHome = '/child/home';
  static const childHomeName = 'child-home';

  static const childActivities = '/child/activities';
  static const childActivitiesName = 'child-activities';

  static const childActivityDetail = '/child/activities/detail';
  static const childActivityDetailName = 'child-activity-detail';

  static const childActivityPlay = '/child/activities/play';
  static const childActivityPlayName = 'child-activity-play';

  static const childActivityResult = '/child/activities/result';
  static const childActivityResultName = 'child-activity-result';

  static const childTutorials = '/child/tutorials';
  static const childTutorialsName = 'child-tutorials';

  static const childTutorialDetail = '/child/tutorials/detail';
  static const childTutorialDetailName = 'child-tutorial-detail';
  // ---------- Catalogue ----------
  static const categories = '/catalogue/categories';
  static const categoriesName = 'categories';

  static const toys = '/catalogue/toys';
  static const toysName = 'toys';

  static const toyDetail = '/catalogue/toys/:toyId';
  static const toyDetailName = 'toy-detail';

  // routes admin
  static const String adminToys = '/admin-toys';
  static const favoris = '/favoris';
  // ---------- Catalogue ----------
  static const parametre = '/parametre';
  static const parametreName = 'parametre';

  static const checkout = '/checkout';
  static const checkoutName = 'checkout';

  static const commandes = '/commandes';
  static const commandesName = 'commandes';

  static const commandeDetail = '/commandes/:commandeId';
  static const commandeDetailName = 'commande-detail';
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
  static const splashName = 'splash';
  static const onboardingName = 'onboarding';

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
  static const favorisName = 'favoris';

  // routes name admin
  static const String adminToysName = 'adminToys';
  // static const Favoris = '/favoris';
}
