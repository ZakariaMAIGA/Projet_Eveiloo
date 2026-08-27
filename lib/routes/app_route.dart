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

  // Sous-routes du catalogue (imbriquées, relatives à /catalogue)
  static const categories = 'categories'; // -> /catalogue/categories
  static const toys = 'toys'; // -> /catalogue/toys
  static const toyDetail = ':toyId'; // -> /catalogue/toys/:toyId

  // route liste complète des enfants (hors shell, poussée depuis le home)
  static const childrenList = '/children';
  // static const cart = '/cart';
  // routes admin
  static const String adminToys = '/admin-toys';
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
  // static const cartName = 'cart';
  static const cartName = 'cart';
  static const cart = '/cart/:id';
  // routes name admin
  static const String adminToysName = 'adminToys';
}
