import 'package:flutter/material.dart';

import '../../../models/activity_model.dart';
import 'activity_category.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback onTap;

  const ActivityCard({super.key, required this.activity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = (activity.progress / 100).clamp(0.0, 1.0);
    final percent = activity.progress.clamp(0.0, 100.0);
    final statusLabel = activity.status.label;
    final isDone = activity.isCompleted;

    // Couleur de la barre de progression selon le pourcentage :
    // rouge doux → orange → bleu ciel → violet,
    // et vert réservé aux activités terminées.
    final Color barColor;
    if (isDone || percent >= 100) {
      barColor = const Color(0xFF36B86A); // verte : terminée
    } else if (percent < 25) {
      barColor = const Color(0xFFEF5350); // rouge doux : à peine commencée
    } else if (percent < 50) {
      barColor = const Color(0xFFFFA726); // orange : en cours de découverte
    } else if (percent < 75) {
      barColor = const Color(0xFF29B6F6); // bleu ciel : bien avancée
    } else {
      barColor = const Color(0xFF7E57C2); // violet : presque finie
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 18, 18, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              // Grande ombre douce diffusée derrière la carte
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
              // Petite ombre courte qui détache la carte du fond
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _ActivityImage(activity: activity),
                  const SizedBox(width: 16),
                  Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            activity.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16.5,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        if (activity.isStarted) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${activity.progress.toInt()}%',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      activity.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.35,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    if (activity.status != ActivityStatus.aFaire) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDone
                              ? const Color(0xFF36B86A).withValues(alpha: 0.15)
                              : const Color(0xFF2D8DD5).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDone
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFF176BA6),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 850),
            curve: Curves.easeOutCubic,
            builder: (context, animatedProgress, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: animatedProgress,
                  minHeight: 7,
                  backgroundColor: const Color(0xFFE5E5E5),
                  valueColor: AlwaysStoppedAnimation<Color>(barColor),
                ),
              );
            },
          ),
        ],
          ),
        ),
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
      width: 66,
      height: 66,
      padding: const EdgeInsets.all(5),
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
                    errorBuilder: (_, error, stackTrace) =>
                        _ImagePlaceholder(category: activity.competenceCategory),
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
