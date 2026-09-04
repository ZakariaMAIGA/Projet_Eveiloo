import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/provider/activite_progress_provider.dart';
import '../../models/activite_progress_model.dart';
import '../../models/activity_model.dart';
import '../../routes/app_route.dart';
import '../children/children_profil.dart'; // enfantParIdProvider
import 'providers/activity_provider.dart';
import 'widgets/activity_card.dart';

/// Calcule l'âge à partir d'une date au format "JJ/MM/AAAA".
int _calculerAge(String dateNaissance) {
  final dateStr = dateNaissance.trim();
  if (dateStr.isEmpty) return 0;

  final parts = dateStr.split('/');
  if (parts.length != 3) return 0;

  final jour = int.tryParse(parts[0]);
  final mois = int.tryParse(parts[1]);
  final annee = int.tryParse(parts[2]);
  if (jour == null || mois == null || annee == null) return 0;

  final naissance = DateTime(annee, mois, jour);
  final now = DateTime.now();
  var age = now.year - naissance.year;
  if (now.month < naissance.month ||
      (now.month == naissance.month && now.day < naissance.day)) {
    age--;
  }
  return age < 0 ? 0 : age;
}

class ActivitiesPage extends ConsumerStatefulWidget {
  /// null = vue parent (catalogue complet, lecture seule, pas de
  /// progression). non-null = vue enfant (filtrée par âge, avec
  /// progression individuelle et possibilité de jouer).
  final String? enfantId;

  const ActivitiesPage({super.key, required this.enfantId});

  @override
  ConsumerState<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends ConsumerState<ActivitiesPage> {
  String _selectedStatus = 'Toutes';

  void _onActivityTap(ActivityModel activity) {
    if (widget.enfantId != null) {
      context.pushNamed(
        AppRoutes.childActivityDetailName,
        extra: (activity: activity, enfantId: widget.enfantId!),
      );
    } else {
      // Mode parent : aperçu en lecture seule (pas de bouton "Jouer").
      context.pushNamed(AppRoutes.activityDetailName, extra: activity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activitiesAsync = ref.watch(activitiesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.enfantId == null
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: const Color(0xFF10158C),
              title: const Text(
                'Activités',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(activitiesProvider),
        child: activitiesAsync.when(
          data: (activites) => widget.enfantId == null
              ? _buildVueParent(activites)
              : _buildVueEnfant(activites, widget.enfantId!),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              _LoadError(onRetry: () => ref.invalidate(activitiesProvider)),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // MODE PARENT : catalogue complet, aucune notion de progression/statut.
  // ---------------------------------------------------------------------
  Widget _buildVueParent(List<ActivityModel> activites) {
    if (activites.isEmpty) {
      return const _EmptyActivities();
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
      children: activites
          .map(
            (activite) => ActivityCard(
              activity: activite,
              onTap: () => _onActivityTap(activite),
              // progress: null ⇒ ActivityCard n'affiche aucune progression
            ),
          )
          .toList(),
    );
  }

  // ---------------------------------------------------------------------
  // MODE ENFANT : filtré par âge + progression individuelle + onglets.
  // ---------------------------------------------------------------------
  Widget _buildVueEnfant(List<ActivityModel> activites, String enfantId) {
    final enfantAsync = ref.watch(enfantParIdProvider(enfantId));
    final progressionAsync = ref.watch(activiteProgressMapProvider(enfantId));

    return enfantAsync.when(
      data: (enfant) {
        if (enfant == null) {
          return const Center(child: Text('Enfant introuvable.'));
        }

        final age = _calculerAge(enfant.dateNaissance);
        final activitesAdaptees = activites
            .where((a) => a.estAdapteeA(age))
            .toList();

        return progressionAsync.when(
          data: (progressions) {
            final visibles = activitesAdaptees.where((activite) {
              final progress = progressions[activite.activityId];
              switch (_selectedStatus) {
                case 'Terminées':
                  return progress?.isCompleted ?? false;
                case 'En cours':
                  return (progress?.isStarted ?? false) &&
                      !(progress?.isCompleted ?? false);
                case 'Toutes':
                default:
                  return true;
              }
            }).toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
              children: [
                Text(
                  'Activités',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF10158C),
                    fontSize: 26,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatusTab(
                        label: 'Toutes',
                        selected: _selectedStatus == 'Toutes',
                        onTap: () => setState(() => _selectedStatus = 'Toutes'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatusTab(
                        label: 'En cours',
                        selected: _selectedStatus == 'En cours',
                        onTap: () =>
                            setState(() => _selectedStatus = 'En cours'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatusTab(
                        label: 'Terminées',
                        selected: _selectedStatus == 'Terminées',
                        onTap: () =>
                            setState(() => _selectedStatus = 'Terminées'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (visibles.isEmpty)
                  const _EmptyActivities()
                else
                  ...visibles.map((activite) {
                    final ActiviteProgressModel? progress =
                        progressions[activite.activityId];
                    return ActivityCard(
                      activity: activite,
                      progress:
                          progress?.score ??
                          (progress?.isCompleted == true ? 100 : 0),
                      onTap: () => _onActivityTap(activite),
                    );
                  }),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(
            child: Text('Erreur de chargement de la progression.'),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) =>
          const Center(child: Text('Erreur de chargement de l\'enfant.')),
    );
  }
}

class _StatusTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _StatusTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFBDEBFF) : Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: selected ? 2 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 42,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? const Color(0xFF111A83) : Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyActivities extends StatelessWidget {
  const _EmptyActivities();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 72),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, size: 52, color: Color(0xFF74B9AD)),
          SizedBox(height: 16),
          Text(
            'Aucune activité disponible',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
          ),
          SizedBox(height: 6),
          Text(
            'Reviens bientôt pour découvrir de nouveaux défis.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  final VoidCallback onRetry;

  const _LoadError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.teal),
            const SizedBox(height: 12),
            const Text(
              'Les activités ne sont pas disponibles.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
