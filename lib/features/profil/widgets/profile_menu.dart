import 'package:eveiloo_enfant/core/provider/auth_provider.dart';
import 'package:eveiloo_enfant/core/provider/enfant_provider.dart';
import 'package:eveiloo_enfant/core/provider/enfant_selectionne_provider.dart';
import 'package:eveiloo_enfant/features/profil/information_personnelles.dart';
import 'package:eveiloo_enfant/models/enfant.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'profile_menu_item.dart';

class ProfileMenu extends ConsumerWidget {
  const ProfileMenu({super.key});

  Future<void> _deconnexion(BuildContext context, WidgetRef ref) async {
    // 1. Déconnecter Firebase
    await ref.read(authActionsProvider.notifier).deconnexion();

    // 2. Reset des providers "utilisateur"
    ref.invalidate(utilisateurCourantProvider);
    ref.invalidate(mesEnfantsProvider);

    // 3. Reset enfant sélectionné
    ref.read(enfantSelectionneProvider.notifier).state = null;

    // 4. Navigation
    if (context.mounted) {
      context.go(AppRoutes.login); // ou '/' si tu as un AuthGate
    }
  }

  Future<void> _ouvrirFavoris(BuildContext context, WidgetRef ref) async {
    final utilisateur = ref.read(utilisateurCourantProvider).value;
    if (utilisateur == null) return;

    final enfants = await ref
        .read(enfantRepositoryProvider)
        .observerEnfants(utilisateur.utilisateurId)
        .first;

    if (!context.mounted) return;

    if (enfants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ajoutez d\'abord un enfant pour voir ses favoris.'),
        ),
      );
      return;
    }

    if (enfants.length == 1) {
      context.pushNamed(
        AppRoutes.favorisName,
        pathParameters: {'enfantId': enfants.first.enfantId},
      );
      return;
    }

    final enfantChoisi = await showDialog<EnfantModel>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Favoris de quel enfant ?'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: enfants.length,
            itemBuilder: (context, index) {
              final enfant = enfants[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: enfant.urlAvatar.isNotEmpty
                      ? NetworkImage(enfant.urlAvatar)
                      : null,
                  child: enfant.urlAvatar.isEmpty
                      ? const Icon(Icons.face)
                      : null,
                ),
                title: Text(enfant.prenom),
                onTap: () => Navigator.of(context).pop(enfant),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );

    if (enfantChoisi != null && context.mounted) {
      context.pushNamed(
        AppRoutes.favorisName,
        pathParameters: {'enfantId': enfantChoisi.enfantId},
      );
    }
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
            color: const Color.fromARGB(20, 0, 0, 0),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
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
            onTap: () => context.pushNamed(AppRoutes.childrenListName),
          ),
          _divider(),
          ProfileMenuItem(
            icon: Icons.inventory_2_outlined,
            title: 'Mes commandes',
            onTap: () => context.pushNamed(AppRoutes.commandesName),
          ),
          _divider(),
          ProfileMenuItem(
            icon: Icons.shopping_basket_outlined,
            title: 'Panier',
            onTap: () => context.pushNamed(AppRoutes.cartName),
          ),
          _divider(),
          ProfileMenuItem(
            icon: Icons.favorite_outline,
            title: 'Favoris',
            onTap: () => _ouvrirFavoris(context, ref),
          ),
          _divider(),
          ProfileMenuItem(
            icon: Icons.settings_outlined,
            title: 'Paramètres',
            onTap: () => context.pushNamed(AppRoutes.parametreName),
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
