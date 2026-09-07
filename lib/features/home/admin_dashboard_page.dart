import 'package:eveiloo_enfant/core/constants/admin_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/provider/admin_dashboard_provider.dart';
import '../../../models/Commande.dart';
import '../../../models/utilisateur.dart';
import '../../widgets/admin_scaffold.dart';
import '../../core/constants/admin_ui.dart';

/// Dashboard admin mobile.
/// Volontairement SANS graphique : uniquement les 4 compteurs clés + les
/// 3 derniers utilisateurs et les 3 dernières commandes.
class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  static const String route = '/admin';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utilisateurs = ref.watch(utilisateursCountProvider);
    final commandes = ref.watch(commandesActuellesCountProvider);
    final jouets = ref.watch(jouetsCountProvider);
    final activites = ref.watch(activitesCountProvider);

    return AdminScaffold(
      title: 'Tableau de bord',
      currentRoute: route,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(utilisateursCountProvider);
          ref.invalidate(commandesActuellesCountProvider);
          ref.invalidate(jouetsCountProvider);
          ref.invalidate(activitesCountProvider);
          ref.invalidate(derniersUtilisateursProvider);
          ref.invalidate(dernieresCommandesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.35,
              children: [
                AdminStatCard(
                  label: 'Utilisateurs',
                  value: utilisateurs.asData?.value.toString() ?? '—',
                  isLoading: utilisateurs.isLoading,
                  icon: Icons.people_alt_rounded,
                  color: AdminColors.primary,
                ),
                AdminStatCard(
                  label: 'Commandes en cours',
                  value: commandes.asData?.value.toString() ?? '—',
                  isLoading: commandes.isLoading,
                  icon: Icons.shopping_bag_rounded,
                  color: AdminColors.pink,
                ),
                AdminStatCard(
                  label: 'Jouets',
                  value: jouets.asData?.value.toString() ?? '—',
                  isLoading: jouets.isLoading,
                  icon: Icons.smart_toy_rounded,
                  color: AdminColors.purple,
                ),
                AdminStatCard(
                  label: 'Activités',
                  value: activites.asData?.value.toString() ?? '—',
                  isLoading: activites.isLoading,
                  icon: Icons.checklist_rtl_rounded,
                  color: AdminColors.success,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const AdminSectionTitle(title: 'Derniers utilisateurs'),
            const SizedBox(height: 12),
            _DerniersUtilisateurs(),
            const SizedBox(height: 24),
            const AdminSectionTitle(title: 'Dernières commandes'),
            const SizedBox(height: 12),
            _DernieresCommandes(),
          ],
        ),
      ),
    );
  }
}

class _DerniersUtilisateurs extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(derniersUtilisateursProvider);

    return AdminCard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, st) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Erreur : $e'),
        ),
        data: (utilisateurs) {
          if (utilisateurs.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Aucun utilisateur pour le moment.',
                style: TextStyle(color: AdminColors.textMuted),
              ),
            );
          }
          return Column(
            children: [for (final u in utilisateurs) _UtilisateurTile(u)],
          );
        },
      ),
    );
  }
}

class _UtilisateurTile extends StatelessWidget {
  const _UtilisateurTile(this.utilisateur);

  final UtilisateurModel utilisateur;

  @override
  Widget build(BuildContext context) {
    final nomComplet = '${utilisateur.prenom} ${utilisateur.nom}'.trim();
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: CircleAvatar(
        backgroundColor: AdminColors.primary.withOpacity(0.12),
        foregroundColor: AdminColors.primary,
        child: Text(
          nomComplet.isNotEmpty ? nomComplet[0].toUpperCase() : '?',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(
        nomComplet.isEmpty ? utilisateur.courriel : nomComplet,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        utilisateur.courriel,
        style: const TextStyle(fontSize: 12.5, color: AdminColors.textMuted),
      ),
      trailing: _RoleBadge(role: utilisateur.role.toValue()),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'admin';
    final color = isAdmin ? AdminColors.purple : AdminColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAdmin ? 'Admin' : 'Parent',
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _DernieresCommandes extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dernieresCommandesProvider);
    final formatMontant = NumberFormat.decimalPattern('fr_FR');

    return AdminCard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, st) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Erreur : $e'),
        ),
        data: (commandes) {
          if (commandes.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Aucune commande pour le moment.',
                style: TextStyle(color: AdminColors.textMuted),
              ),
            );
          }
          return Column(
            children: [
              for (final c in commandes)
                _CommandeTile(commande: c, formatMontant: formatMontant),
            ],
          );
        },
      ),
    );
  }
}

class _CommandeTile extends StatelessWidget {
  const _CommandeTile({required this.commande, required this.formatMontant});

  final Commande commande;
  final NumberFormat formatMontant;

  Color _couleurStatut(StatutCommande statut) {
    switch (statut) {
      case StatutCommande.livree:
        return AdminColors.success;
      case StatutCommande.annulee:
        return Colors.redAccent;
      case StatutCommande.expediee:
        return AdminColors.primary;
      case StatutCommande.confirmee:
        return AdminColors.orange;
      case StatutCommande.enAttente:
        return AdminColors.textMuted;
    }
  }

  String _libelleStatut(StatutCommande statut) {
    switch (statut) {
      case StatutCommande.livree:
        return 'Livrée';
      case StatutCommande.annulee:
        return 'Annulée';
      case StatutCommande.expediee:
        return 'Expédiée';
      case StatutCommande.confirmee:
        return 'Confirmée';
      case StatutCommande.enAttente:
        return 'En attente';
    }
  }

  @override
  Widget build(BuildContext context) {
    final couleur = _couleurStatut(commande.statut);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: couleur.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.receipt_long_rounded, color: couleur, size: 20),
      ),
      title: Text(
        commande.numeroCommande,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        '${formatMontant.format(commande.montantTotal)} F CFA',
        style: const TextStyle(fontSize: 12.5, color: AdminColors.textMuted),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: couleur.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _libelleStatut(commande.statut),
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: couleur,
          ),
        ),
      ),
    );
  }
}
