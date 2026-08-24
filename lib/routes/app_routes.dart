import 'package:go_router/go_router.dart';
import '../features/toys/categories_toys_page.dart';
import '../features/toys/toys_page.dart';
import '../features/toys/toy_detail_page.dart';
import '../features/toys/admin_toys_page.dart'; // Import ajouté
import '../models/toy_model.dart';

class AppRoutes {
  static const String categories = '/';
  static const String toys = '/toys';
  static const String toyDetail = '/toy-detail';
  static const String adminToys = '/admin-toys';

  static final GoRouter router = GoRouter(
    initialLocation: categories,
    routes: [
      GoRoute(
        path: categories,
        name: 'categories',
        builder: (context, state) => const CategoriesToysPage(),
      ),
      GoRoute(
        path: toys,
        name: 'toys',
        builder: (context, state) {
          final genre = state.uri.queryParameters['genre'] ?? 'fille';
          return ToysPage(genre: genre);
        },
      ),
      GoRoute(
        path: toyDetail,
        name: 'toy-detail',
        builder: (context, state) {
          final toy = state.extra as ToyModel;
          return ToyDetailPage(toy: toy);
        },
      ),
      // Route Administration ajoutée
      GoRoute(
        path: adminToys,
        name: 'admin-toys',
        builder: (context, state) {
          final categorieId = state.uri.queryParameters['categorieId'];
          final categorieNom = state.uri.queryParameters['categorieNom'];
          return AdminToysPage(
            categorieId: categorieId,
            categorieNom: categorieNom,
          );
        },
      ),
    ],
  );
}
