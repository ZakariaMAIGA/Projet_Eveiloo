import 'package:eveiloo_enfant/core/provider/auth_provider.dart';
import 'package:eveiloo_enfant/core/provider/enfant_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/enfant.dart';
import '../../models/journal_progres_model.dart';
import '../../repository/journal_progres_repository.dart';
import '../../routes/app_route.dart';
import '../activities/activity_service.dart';

// Widgets extraits
import 'widgets/section_title.dart';
import 'widgets/entete_profil.dart';
import 'widgets/barre_progression.dart';
import 'widgets/activity_card_premium.dart';
import 'widgets/grille_actions_premium.dart';

// ---------------------------------------------------------------------------
// Providers locaux
// ---------------------------------------------------------------------------
final journalProgresRepositoryProvider = Provider<JournalProgresRepository>((
  ref,
) {
  return JournalProgresRepository();
});

final activityServiceProvider = Provider<ActivityService>((ref) {
  return ActivityService();
});

/// Stream d'un enfant précis
final enfantParIdProvider = StreamProvider.family<EnfantModel?, String>((
  ref,
  enfantId,
) {
  final utilisateur = ref.watch(utilisateurCourantProvider).value;
  if (utilisateur == null) return Stream.value(null);

  return ref
      .watch(enfantRepositoryProvider)
      .observerEnfantParId(utilisateur.utilisateurId, enfantId);
});

// ---------------------------------------------------------------------------
// Page principale
// ---------------------------------------------------------------------------
class ChildrenProfil extends ConsumerStatefulWidget {
  final String enfantId;

  const ChildrenProfil({super.key, required this.enfantId});

  @override
  ConsumerState<ChildrenProfil> createState() => _ChildrenProfilState();
}

class _ChildrenProfilState extends ConsumerState<ChildrenProfil> {
  static const int _objectifPalier = 25;

  String _libelleNiveau(int activitesRealisees) {
    if (activitesRealisees >= 25) return 'Maître de l\'aventure 🌟';
    if (activitesRealisees >= 15) return 'Super Explorateur 🚀';
    if (activitesRealisees >= 5) return 'Apprenti Curieux 🔎';
    return 'Petit Débutant 🌱';
  }

  double _valeurProgression(int activitesRealisees) {
    return (activitesRealisees / _objectifPalier).clamp(0.0, 1.0);
  }

  String _descriptionEntree(JournalProgresModel entree, String prenom) {
    return entree.typeElement == TypeElementProgres.tutoriel
        ? '$prenom a regardé un tutoriel captivant'
        : '$prenom a complété une activité avec succès';
  }

  String _tempsEcoule(DateTime? date) {
    if (date == null) return '';

    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return 'Il y a $h ${h > 1 ? 'heures' : 'heure'}';
    }

    final j = diff.inDays;
    return 'Il y a $j ${j > 1 ? 'jours' : 'jour'}';
  }

  Future<void> _ouvrirEntreeJournal(JournalProgresModel entree) async {
    if (entree.typeElement == TypeElementProgres.tutoriel) {
      if (!mounted) return;
      context.go(AppRoutes.tutorials);
      return;
    }

    final activityService = ref.read(activityServiceProvider);
    final activite = await activityService.getActivity(entree.elementId);

    if (activite == null || !mounted) return;

    context.go(AppRoutes.childActivityDetail, extra: activite);
  }

  void _voirToutHistorique() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Historique complet — bientôt disponible ! ✨'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final enfantAsync = ref.watch(enfantParIdProvider(widget.enfantId));

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF29258F),
              size: 20,
            ),
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.childrenList);
            }
          },
        ),
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Color(0xFF29258F),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: enfantAsync.when(
        data: (enfant) {
          if (enfant == null) {
            return const Center(
              child: Text(
                'Enfant introuvable.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return _buildContent(enfant);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF29258F)),
        ),
        error: (_, __) => const Center(child: Text('Une erreur est survenue.')),
      ),
    );
  }

  Widget _buildContent(EnfantModel enfant) {
    final journalRepo = ref.watch(journalProgresRepositoryProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40, top: 10),
      child: Column(
        children: [
          EnteteProfil(nomEnfant: enfant.prenom, urlAvatar: enfant.urlAvatar),
          const SizedBox(height: 24),
          BarreProgression(
            niveau: _libelleNiveau(enfant.activitesRealisees),
            numeroNiveau: enfant.niveauAtteint,
            valeur: _valeurProgression(enfant.activitesRealisees),
            activitesRealisees: enfant.activitesRealisees,
            objectif: _objectifPalier,
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionTitle(title: 'Activités Récentes ✨'),
                GestureDetector(
                  onTap: _voirToutHistorique,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Voir tout',
                        style: TextStyle(
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF6C63FF),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          StreamBuilder<List<JournalProgresModel>>(
            stream: journalRepo.observerActivitesRecentes([
              widget.enfantId,
            ], limite: 3),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const SizedBox.shrink();

              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(color: Color(0xFF29258F)),
                );
              }

              final entrees = snapshot.data!;

              if (entrees.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text(
                    'Aucune aventure pour le moment, c\'est l\'heure de jouer !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: entrees.map((entree) {
                    return ActivityCardPremium(
                      urlAvatar: enfant.urlAvatar,
                      titre: entree.titre,
                      description: _descriptionEntree(entree, enfant.prenom),
                      tempsEcoule: _tempsEcoule(entree.dateRealisation),
                      onTap: () => _ouvrirEntreeJournal(entree),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          const GrilleActionsPremium(),
        ],
      ),
    );
  }
}
