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
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        clipBehavior: Clip.antiAlias,
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
                  child: SizedBox(
                    height: 54,
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
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${activity.progress.toInt()}%',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Text(
                          activity.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10, height: 1.15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
                    valueColor: AlwaysStoppedAnimation<Color>(
                      activity.progress >= 100
                          ? const Color(0xFF36B86A)
                          : const Color(0xFF1118F5),
                    ),
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
      width: 58,
      height: 58,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _gradientFor(activity.competenceCategory),
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

  LinearGradient _gradientFor(String category) {
    const gradients = [
      LinearGradient(
        colors: [Color(0xFF243BFF), Color(0xFFE91E9B), Color(0xFFFFA31A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Color(0xFF16B9D4), Color(0xFF5DD45A), Color(0xFFF0D52D)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      LinearGradient(
        colors: [Color(0xFF7656E8), Color(0xFFEF4E9D), Color(0xFFFF8B37)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      LinearGradient(
        colors: [Color(0xFF1D9BF0), Color(0xFF7A5AF8), Color(0xFF3CCB9A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ];
    final index = activity.activityId.codeUnits.fold<int>(
          0,
          (total, codeUnit) => total + codeUnit,
        ) %
        gradients.length;
    return gradients[index];
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
