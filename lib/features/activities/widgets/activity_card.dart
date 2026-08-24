import 'package:flutter/material.dart';

import '../../../models/activity_model.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback onTap;

  const ActivityCard({super.key, required this.activity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = (activity.progress / 100).clamp(0.0, 1.0);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 156,
              child: activity.imageUrl != null
                  ? Image.network(
                      activity.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, error, stackTrace) => _ImagePlaceholder(
                        category: activity.competenceCategory,
                      ),
                    )
                  : _ImagePlaceholder(category: activity.competenceCategory),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.competenceCategory.toUpperCase(),
                    style: TextStyle(
                      color: Colors.teal.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    activity.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF173B35),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    activity.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      _Meta(
                        icon: Icons.star_rounded,
                        text: '${activity.rewardPoints} pts',
                      ),

                      const SizedBox(width: 10),

                      _Meta(
                        icon: Icons.timer_outlined,
                        text: '${activity.duration} min',
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFE5EFEC),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${activity.progress.toInt()} % terminé',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.teal,
                      ),
                    ],
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

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Meta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: Colors.teal.shade700),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final String category;

  const _ImagePlaceholder({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFDDF2EC),
      child: Center(
        child: Icon(
          category.toLowerCase().contains('math')
              ? Icons.calculate_outlined
              : Icons.auto_awesome,
          size: 58,
          color: Colors.teal.shade600,
        ),
      ),
    );
  }
}
