import 'package:eveiloo_enfant/features/children/add_children_page.dart';
import 'package:eveiloo_enfant/features/children/children_page.dart'; // MesEnfantsPage
import 'package:eveiloo_enfant/features/children/children_profil.dart'; // ChildrenProfil
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> childrenRoutes = [
  // Liste des enfants
  GoRoute(
    path: AppRoutes.childrenList, // '/children'
    name: AppRoutes.childrenListName,
    builder: (context, state) => const MesEnfantsPage(),
  ),

  // Ajouter un enfant
  GoRoute(
    path: AppRoutes.childrenAdd, // '/children/add'
    name: AppRoutes.childrenAddName,
    builder: (context, state) => const ProfilEnfantPage(),
  ),

  // Dashboard / Profil de l'enfant
  GoRoute(
    path: AppRoutes.childrenProfil, // '/children/:id/dashboard'
    name: AppRoutes.childrenProfilName,
    builder: (context, state) {
      final enfantId = state.pathParameters['enfantId']!;
      return ChildrenProfil(enfantId: enfantId);
    },
  ),
];
