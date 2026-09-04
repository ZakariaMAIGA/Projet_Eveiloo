import 'package:flutter/material.dart';

import '../../../models/activity_model.dart';
import 'activity_category.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback onTap;

  /// null = mode parent : pas de progression à afficher du tout.
  /// non-null = mode enfant : pourcentage 0-100 pour cet enfant précis.
  final double? progress;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final category = categoryStyle(activity.competenceCategory);
    final afficherProgression = progress != null;
    final progressValue = ((progress ?? 0) / 100).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(11),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 9, 12, 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ActivityImage(activity: activity),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  activity.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (afficherProgression)
                                Text(
                                  '${progress!.toInt()}%',
                                  style: const TextStyle(fontSize: 13),
                                ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Text(
                            activity.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14, height: 1.15),
                          ),
                          const SizedBox(height: 6),
                          _badgeAge(),
                        ],
                      ),
                    ),
                  ],
                ),
                if (afficherProgression) ...[
                  const SizedBox(height: 10),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progressValue),
                    duration: const Duration(milliseconds: 850),
                    curve: Curves.easeOutCubic,
                    builder: (context, animatedProgress, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: animatedProgress,
                          minHeight: 7,
                          backgroundColor: const Color(0xFFE5E5E5),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            (progress ?? 0) >= 100
                                ? const Color(0xFF36B86A)
                                : category.accent,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _badgeAge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${activity.minAge}-${activity.maxAge} ans',
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ActivityImage extends StatelessWidget {
  final ActivityModel activity;

  const _ActivityImage({required this.activity});

  @override
  Widget build(BuildContext context) {
    final image = activity.imageUrl;
    return Container(
      width: 58,
      height: 58,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: categoryStyle(activity.competenceCategory).gradient,
      ),
      child: ClipOval(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(3),
          child: ClipOval(
            child: image != null && image.isNotEmpty
                ? Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, error, stackTrace) => _ImagePlaceholder(
                      category: activity.competenceCategory,
                    ),
                  )
                : _ImagePlaceholder(category: activity.competenceCategory),
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final String category;

  const _ImagePlaceholder({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: category.toLowerCase().contains('math')
          ? const Color(0xFFE4F7B8)
          : const Color(0xFFFFE4F0),
      child: Center(
        child: Icon(
          category.toLowerCase().contains('math')
              ? Icons.calculate_outlined
              : category.toLowerCase().contains('cré')
              ? Icons.palette_outlined
              : Icons.menu_book_rounded,
          size: 30,
          color: category.toLowerCase().contains('math')
              ? const Color(0xFF36B86A)
              : const Color(0xFFE9168C),
        ),
      ),
    );
  }
}
