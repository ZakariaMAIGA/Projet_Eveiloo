import 'package:eveiloo_enfant/features/favoris/favoris.dart';
import 'package:eveiloo_enfant/features/toys/categories_toys_page.dart';
import 'package:eveiloo_enfant/features/toys/toy_detail_page.dart';
import 'package:eveiloo_enfant/features/toys/toys_page.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> catalogueRoutes = [
  GoRoute(
    path: AppRoutes.catalogue,
    name: AppRoutes.catalogueName,
    builder: (context, state) {
      final enfantId = state.uri.queryParameters['enfantId'];
      return CategoriesToysPage(enfantId: enfantId);
    },
    routes: [
      // /catalogue/toys?genre=fille&categorieId=...&enfantId=...
      GoRoute(
        path: AppRoutes.toys,
        name: AppRoutes.toysName,
        builder: (context, state) {
          final params = state.uri.queryParameters;
          return ToysPage(
            genre: params['genre'] ?? 'fille',
            categorieId: params['categorieId'],
            categorieNom: params['categorieNom'],
            enfantId: params['enfantId'],
          );
        },
        routes: [
          // /catalogue/toys/:toyId?enfantId=...
          GoRoute(
            path: AppRoutes.toyDetail,
            name: AppRoutes.toyDetailName,
            builder: (context, state) {
              final toyId = state.pathParameters['toyId']!;
              final enfantId = state.uri.queryParameters['enfantId'];
              return ToyDetailPage(toyId: toyId, enfantId: enfantId);
            },
          ),
        ],
      ),
    ],
  ),

  // /favoris/:enfantId (accessible parent ET enfant, filtré par enfant)
  // ?mode=enfant quand ouvert depuis le dashboard enfant : le jouet
  // ouvert depuis là reste en lecture seule (pas d'achat possible).
  GoRoute(
    path: AppRoutes.favoris,
    name: AppRoutes.favorisName,
    builder: (context, state) {
      final enfantId = state.pathParameters['enfantId']!;
      final modeEnfant = state.uri.queryParameters['mode'] == 'enfant';
      return Favoris(
        enfantId: enfantId,
        onVoirLeJouet: (jouetId) {
          context.pushNamed(
            AppRoutes.toyDetailName,
            pathParameters: {'toyId': jouetId},
            queryParameters: modeEnfant ? {'enfantId': enfantId} : {},
          );
        },
      );
    },
  ),
];
