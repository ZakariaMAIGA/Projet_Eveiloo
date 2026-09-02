import 'package:eveiloo_enfant/core/services/auth_service.dart';
import 'package:eveiloo_enfant/models/enfant.dart';
import 'package:eveiloo_enfant/models/journal_progres_model.dart';
import 'package:eveiloo_enfant/models/utilisateur.dart';
import 'package:eveiloo_enfant/repository/enfant_repository.dart';
import 'package:eveiloo_enfant/repository/journal_progres_repository.dart';
import 'package:eveiloo_enfant/repository/utilisateurRepository.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/activity_category_chip.dart';
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
          'assets/images/logo_eveiloo.png', // ← adapte selon ton projet
          height: 50, // ajuste la hauteur du logo
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
                        _buildSectionHeader('Catégories d\'activités'),
                        const SizedBox(height: 12),
                        _buildCategoriesList(),
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
            // On log l'erreur réelle (ex: permission-denied) au lieu de la
            // traiter silencieusement comme "aucun enfant".
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

  Widget _buildCategoriesList() {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: kActivityCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final categorie = kActivityCategories[index];

          return ActivityCategoryChip(
            category: categorie,
            onTap: () => context.push(
              '${AppRoutes.activities}?categorie=${categorie.label}',
            ),
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

            // Trier par date (plus récent en premier) et garder les 2 premières
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
