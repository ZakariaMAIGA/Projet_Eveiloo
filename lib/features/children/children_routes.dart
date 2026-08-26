import 'package:eveiloo_enfant/features/children/children_list_page.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:go_router/go_router.dart';

/// Route hors shell (poussée par-dessus la bottom nav, pas un tab).
final List<RouteBase> childrenRoutes = [
  GoRoute(
    path: AppRoutes.childrenList,
    name: AppRoutes.childrenListName,
    builder: (context, state) => const ChildrenListPage(),
  ),
];
