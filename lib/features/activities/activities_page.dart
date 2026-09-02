import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/activity_model.dart';
import '../../routes/app_route.dart';
import 'providers/activity_provider.dart';
import 'widgets/activity_card.dart';
import 'child/activity_detail_page.dart';

class ActivitiesPage extends ConsumerStatefulWidget {
  const ActivitiesPage({super.key});

  @override
  ConsumerState<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends ConsumerState<ActivitiesPage> {
  String _selectedStatus = 'Toutes';

  @override
  Widget build(BuildContext context) {
    final activities = ref.watch(activitiesProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(activitiesProvider),
        child: activities.when(
          data: (list) => _ActivityList(
            activities: list,
            selectedStatus: _selectedStatus,
            onStatusSelected: (status) {
              setState(() => _selectedStatus = status);
            },
            onActivityTap: (activity) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ActivityDetailPage(activity: activity),
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, stackTrace) =>
              _LoadError(onRetry: () => ref.invalidate(activitiesProvider)),
        ),
      ),
      bottomNavigationBar: _ChildNavigationBar(
        onHomePressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _ActivityList extends StatelessWidget {
  final List<ActivityModel> activities;
  final String selectedStatus;
  final ValueChanged<String> onStatusSelected;
  final ValueChanged<ActivityModel> onActivityTap;

  const _ActivityList({
    required this.activities,
    required this.selectedStatus,
    required this.onStatusSelected,
    required this.onActivityTap,
  });

  @override
  Widget build(BuildContext context) {
        final visibleActivities = activities.where((activity) {
      if (selectedStatus == 'Toutes') return true;
      if (selectedStatus == 'Terminées') return activity.isCompleted;
      // « En cours » : démarrée mais pas encore terminée.
      return activity.isStarted && !activity.isCompleted;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 34, 22, 20),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Activités',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF10158C),
                  fontSize: 26,
                  height: 1.1,
                ),
              ),
            ),
            // Lien vers le côté admin pour créer / gérer les activités.
            IconButton(
              onPressed: () => context.go(AppRoutes.adminActivities),
              tooltip: 'Mode admin',
              icon: const Icon(Icons.admin_panel_settings_outlined),
              color: const Color(0xFF10158C),
            ),
          ],
        ),
                Row(
          children: [
            Expanded(child: _StatusTab(
              label: 'Toutes',
              selected: selectedStatus == 'Toutes',
              onTap: () => onStatusSelected('Toutes'),
            )),
            const SizedBox(width: 8),
            Expanded(child: _StatusTab(
              label: 'En cours',
              selected: selectedStatus == 'En cours',
              onTap: () => onStatusSelected('En cours'),
            )),
            const SizedBox(width: 8),
            Expanded(child: _StatusTab(
              label: 'Terminées',
              selected: selectedStatus == 'Terminées',
              onTap: () => onStatusSelected('Terminées'),
            )),
          ],
        ),
        const SizedBox(height: 18),
        if (visibleActivities.isEmpty)
          const _EmptyActivities()
        else
          ...visibleActivities.map(
            (activity) => ActivityCard(
              activity: activity,
              onTap: () => onActivityTap(activity),
            ),
          ),
      ],
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

class _ChildNavigationBar extends StatelessWidget {
  final VoidCallback onHomePressed;

  const _ChildNavigationBar({required this.onHomePressed});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavigationItem(
            icon: Icons.home_rounded,
            label: 'Accueil',
            onTap: onHomePressed,
          ),
          const _NavigationItem(icon: Icons.live_tv_outlined, label: 'Tutoriel'),
          const _NavigationItem(icon: Icons.toys_outlined, label: 'Jouets'),
          const _NavigationItem(
            icon: Icons.directions_run_rounded,
            label: 'Activités',
            selected: true,
          ),
        ],
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _NavigationItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? const Color(0xFF4CAF50) : Colors.black54,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: selected ? const Color(0xFF4CAF50) : Colors.black54,
              ),
            ),
          ],
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
