import 'package:eveiloo_enfant/features/toys/categories_toys_page.dart';
import 'package:eveiloo_enfant/features/toys/toy_detail_page.dart';
import 'package:eveiloo_enfant/features/toys/toys_page.dart';
import 'package:eveiloo_enfant/models/toy_model.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> catalogueRoutes = [
  GoRoute(
    path: AppRoutes.catalogue,
    name: AppRoutes.catalogueName,
    // L'écran racine du catalogue affiche directement les catégories.
    builder: (context, state) => const CategoriesToysPage(),
    routes: [
      // /catalogue/toys?genre=fille
      GoRoute(
        path: AppRoutes.toys,
        name: AppRoutes.toysName,
        builder: (context, state) {
          final genre = state.uri.queryParameters['genre'] ?? 'fille';
          return ToysPage(genre: genre);
        },
        routes: [
          // /catalogue/toys/:toyId
          GoRoute(
            path: AppRoutes.toyDetail,
            name: AppRoutes.toyDetailName,
            builder: (context, state) {
              final toy = state.extra as ToyModel;
              return ToyDetailPage(toy: toy);
            },
          ),
        ],
      ),
    ],
  ),
];
