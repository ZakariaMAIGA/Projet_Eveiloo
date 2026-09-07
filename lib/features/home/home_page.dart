import 'package:eveiloo_enfant/core/services/auth_service.dart';
import 'package:eveiloo_enfant/models/enfant.dart';
import 'package:eveiloo_enfant/models/journal_progres_model.dart';
import 'package:eveiloo_enfant/models/toy_model.dart';
import 'package:eveiloo_enfant/models/utilisateur.dart';
import 'package:eveiloo_enfant/repository/enfant_repository.dart';
import 'package:eveiloo_enfant/repository/journal_progres_repository.dart';
import 'package:eveiloo_enfant/repository/toy_repository.dart';
import 'package:eveiloo_enfant/repository/utilisateurRepository.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/child_card.dart';
import 'widgets/recent_activity_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final UtilisateurRepository _utilisateurRepository = UtilisateurRepository();
  final EnfantRepository _enfantRepository = EnfantRepository();
  final JournalProgresRepository _journalRepository =
      JournalProgresRepository();
  final ToyRepository _toyRepository = ToyRepository();

  // Couleurs cycliques pour les cartes enfants (rose, bleu, violet, teal...)
  static const _accents = [
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.deepPurpleAccent,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    final parentId = _authService.utilisateurFirebase?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo_eveiloo.png',
          height: 50,
          fit: BoxFit.contain,
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              context.push('/notifications');
            },
          ),
        ],
      ),
      body: parentId == null
          ? const Center(child: Text('Aucun utilisateur connecté'))
          : SafeArea(
              child: StreamBuilder<UtilisateurModel?>(
                stream: _utilisateurRepository.observerParId(parentId),
                builder: (context, utilisateurSnapshot) {
                  final prenom = utilisateurSnapshot.data?.prenom ?? '';

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(prenom),
                        const SizedBox(height: 24),
                        _buildSectionHeader(
                          'Mes enfants',
                          onSeeAll: () =>
                              context.pushNamed(AppRoutes.childrenListName),
                        ),
                        const SizedBox(height: 12),
                        _buildChildrenList(parentId),
                        const SizedBox(height: 28),
                        _buildSectionHeader(
                          'Nouveautés',
                          onSeeAll: () =>
                              context.pushNamed(AppRoutes.catalogueName),
                        ),
                        const SizedBox(height: 12),
                        _buildDerniersJouets(),
                        const SizedBox(height: 28),
                        _buildSectionHeader('Activités récentes'),
                        const SizedBox(height: 8),
                        _buildRecentActivities(parentId),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildHeader(String prenom) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bonjour${prenom.isNotEmpty ? ', $prenom' : ''}',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Voici un aperçu des activités de vos enfants',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String titre, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titre,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (onSeeAll != null)
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onPressed: onSeeAll,
          ),
      ],
    );
  }

  Widget _buildChildrenList(String parentId) {
    return SizedBox(
      height: 195,
      child: StreamBuilder<List<EnfantModel>>(
        stream: _enfantRepository.observerEnfants(parentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint('Erreur observerEnfants: ${snapshot.error}');
            return Center(
              child: Text(
                'Impossible de charger les enfants.\n${snapshot.error}',
                style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            );
          }

          final enfants = snapshot.data ?? [];

          if (enfants.isEmpty) {
            return _buildAjouterEnfantCard();
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: enfants.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final enfant = enfants[index];
              final couleur = _accents[index % _accents.length];

              return ChildCard(
                enfant: enfant,
                accentColor: couleur,
                onTap: () => context.pushNamed(
                  AppRoutes.progressionName,
                  pathParameters: {'enfantId': enfant.enfantId},
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAjouterEnfantCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        context.pushNamed(AppRoutes.childrenAddName);
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 32, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Ajouter un enfant',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // NOUVEAUTÉS : 5 derniers jouets ajoutés au catalogue.
  // ---------------------------------------------------------------------
  Widget _buildDerniersJouets() {
    return SizedBox(
      height: 190,
      child: StreamBuilder<List<ToyModel>>(
        stream: _toyRepository.observerDerniersJouets(limite: 5),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint('Erreur observerDerniersJouets: ${snapshot.error}');
            return Center(
              child: Text(
                'Impossible de charger les nouveautés.',
                style: TextStyle(color: Colors.red.shade700, fontSize: 12),
              ),
            );
          }

          final jouets = snapshot.data ?? [];

          if (jouets.isEmpty) {
            return Center(
              child: Text(
                'Aucun jouet pour le moment.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            );
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: jouets.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _ToyCardHome(toy: jouets[index]),
          );
        },
      ),
    );
  }

  Widget _buildRecentActivities(String parentId) {
    return StreamBuilder<List<EnfantModel>>(
      stream: _enfantRepository.observerEnfants(parentId),
      builder: (context, enfantsSnapshot) {
        final enfants = enfantsSnapshot.data ?? [];

        if (enfants.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Ajoutez un enfant pour voir ses activités ici.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          );
        }

        final enfantIds = enfants.map((e) => e.enfantId).toList();
        final prenomParId = {for (final e in enfants) e.enfantId: e.prenom};

        return StreamBuilder<List<JournalProgresModel>>(
          stream: _journalRepository.observerActivitesRecentes(enfantIds),
          builder: (context, journalSnapshot) {
            if (journalSnapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final entrees = journalSnapshot.data ?? [];

            if (entrees.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Aucune activité récente pour le moment.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              );
            }

            final entreesTriees = List<JournalProgresModel>.from(entrees)
              ..sort((a, b) {
                final dateA = a.dateRealisation ?? DateTime(0);
                final dateB = b.dateRealisation ?? DateTime(0);
                return dateB.compareTo(dateA);
              });

            final deuxDernieres = entreesTriees.take(2).toList();

            return Column(
              children: deuxDernieres
                  .map(
                    (entree) => RecentActivityTile(
                      entree: entree,
                      prenomEnfant: prenomParId[entree.enfantId] ?? '',
                    ),
                  )
                  .toList(),
            );
          },
        );
      },
    );
  }
}

/// Carte compacte pour un jouet, dans la section "Nouveautés" du home.
class _ToyCardHome extends StatelessWidget {
  final ToyModel toy;

  const _ToyCardHome({required this.toy});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.pushNamed(
        AppRoutes.toyDetailName,
        pathParameters: {'toyId': toy.id},
      ),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                height: 100,
                color: Colors.grey.shade100,
                child: toy.imageUrl.isNotEmpty
                    ? Image.network(
                        toy.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.smart_toy_rounded,
                              color: Colors.grey,
                              size: 32,
                            ),
                      )
                    : const Icon(
                        Icons.smart_toy_rounded,
                        color: Colors.grey,
                        size: 32,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    toy.nom,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${toy.prix.toInt()} FCFA',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xFF29B6F6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
