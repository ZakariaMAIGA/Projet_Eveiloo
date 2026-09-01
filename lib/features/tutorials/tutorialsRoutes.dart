import 'package:eveiloo_enfant/features/commandes/mes_commandes_page.dart';
import 'package:eveiloo_enfant/features/tutorials/tutorial_page.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> tutorialsRoutes = [
  GoRoute(
    path: AppRoutes.tutorials,
    name: AppRoutes.tutorialsName,
    builder: (context, state) => const MesCommandesPage(),
  ),
];
