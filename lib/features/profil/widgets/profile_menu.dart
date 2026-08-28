import 'package:eveiloo_enfant/core/provider/auth_provider.dart';
import 'package:eveiloo_enfant/features/profil/information_personnelles.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'profile_menu_item.dart';

class ProfileMenu extends ConsumerWidget {
  const ProfileMenu({super.key});

  Future<void> _deconnexion(BuildContext context, WidgetRef ref) async {
    await ref.read(authActionsProvider.notifier).deconnexion();

    // Pas de `redirect` sur le GoRouter qui ecoute l'etat d'authentification :
    // on navigue explicitement, en remplacant toute la pile (retour arriere
    // impossible vers les ecrans proteges apres deconnexion).
    if (context.mounted) context.go(AppRoutes.login);
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Divider(height: 10, color: Color.fromARGB(19, 0, 0, 0)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deconnexionEnCours = ref.watch(authActionsProvider).isLoading;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(20, 0, 0, 0), // couleur de l'ombre
            spreadRadius: 1, // étalement
            blurRadius: 5, // flou
            offset: const Offset(0, 2), // décalage (x, y)
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Informations personnelles',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const InformationsPersonnellesPage(),
                ),
              );
            },
          ),

          _divider(),

          ProfileMenuItem(
            icon: Icons.child_care,
            title: 'Mes enfants',
            onTap: () {
              context.pushNamed(AppRoutes.childrenListName);
            },
          ),

          _divider(),

          ProfileMenuItem(
            icon: Icons.inventory_2_outlined,
            title: 'Mes commandes',
            onTap: () {
              // TODO: créer la page + la route "mes commandes"
            },
          ),

          _divider(),

          ProfileMenuItem(
            icon: Icons.shopping_basket_outlined,
            title: 'Panier',
            onTap: () {
              // TODO: brancher sur la route existante de features/cart
            },
          ),

          _divider(),

          ProfileMenuItem(
            icon: Icons.favorite_outline,
            title: 'Favoris',
            onTap: () {
              // TODO: créer la page + la route "favoris"
            },
          ),

          _divider(),

          ProfileMenuItem(
            icon: Icons.settings_outlined,
            title: 'Paramètres',
            onTap: () {
              // TODO: créer la page + la route "paramètres"
            },
          ),

          _divider(),

          ProfileMenuItem(
            icon: Icons.logout,
            title: deconnexionEnCours ? 'Déconnexion...' : 'Se déconnecter',
            iconColor: deconnexionEnCours ? Colors.grey : null,
            onTap: deconnexionEnCours ? null : () => _deconnexion(context, ref),
          ),
        ],
      ),
    );
  }
}
