import 'package:eveiloo_enfant/features/profil/profil_page.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> profileRoutes = [
  GoRoute(
    path: AppRoutes.profile,
    name: AppRoutes.profileName,
    builder: (context, state) => const ProfilPage(),
  ),
];
