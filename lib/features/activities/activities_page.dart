import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/activity_model.dart';
import 'providers/activity_provider.dart';
import 'widgets/activity_card.dart';
import 'child/activity_detail_page.dart';

class ActivitiesPage extends ConsumerStatefulWidget {
  const ActivitiesPage({super.key});

  @override
  ConsumerState<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends ConsumerState<ActivitiesPage> {
  String _selectedCategory = 'Toutes';

  @override
  Widget build(BuildContext context) {
    final activities = ref.watch(activitiesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Activités')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(activitiesProvider),
        child: activities.when(
          data: (list) => _ActivityList(
            activities: list,
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() => _selectedCategory = category);
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
    );
  }
}

class _ActivityList extends StatelessWidget {
  final List<ActivityModel> activities;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<ActivityModel> onActivityTap;

  const _ActivityList({
    required this.activities,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onActivityTap,
  });

  @override
  Widget build(BuildContext context) {
    final categories = <String>{
      'Toutes',
      ...activities
          .map((activity) => activity.competenceCategory.trim())
          .where((category) => category.isNotEmpty),
    }.toList();
    final visibleActivities = selectedCategory == 'Toutes'
        ? activities
        : activities
              .where(
                (activity) => activity.competenceCategory == selectedCategory,
              )
              .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text(
          'Prêt à apprendre ?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF173B35),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Choisis une activité et progresse à ton rythme.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF5C706A)),
        ),
        const SizedBox(height: 22),
        if (activities.isNotEmpty)
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, index) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final category = categories[index];
                return ChoiceChip(
                  label: Text(category),
                  selected: category == selectedCategory,
                  onSelected: (_) => onCategorySelected(category),
                );
              },
            ),
          ),
        const SizedBox(height: 20),
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
