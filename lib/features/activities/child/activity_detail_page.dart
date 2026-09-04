import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/provider/activite_progress_provider.dart';
import '../../../models/activity_model.dart';
import '../widgets/activity_category.dart';

class ActivityDetailPage extends ConsumerWidget {
  final ActivityModel activity;
  final String? enfantId; // null => parent, lecture seule

  const ActivityDetailPage({super.key, required this.activity, this.enfantId});

  bool get modeJouable => enfantId != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = categoryStyle(activity.competenceCategory);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF29258F),
            size: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: activity.activityId,
                child: Container(
                  width: 112,
                  height: 112,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: category.gradient,
                  ),
                  child: ClipOval(
                    child: activity.imageUrl != null
                        ? Image.network(
                            activity.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, error, stackTrace) =>
                                const ColoredBox(
                                  color: Color(0xFFFFE4F0),
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    color: Color(0xFFE91E9B),
                                    size: 52,
                                  ),
                                ),
                          )
                        : const ColoredBox(
                            color: Color(0xFFFFE4F0),
                            child: Icon(
                              Icons.menu_book_rounded,
                              color: Color(0xFFE91E9B),
                              size: 52,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF29258F),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    activity.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${activity.minAge}-${activity.maxAge} ans',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDF4FB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Objectif',
                          style: TextStyle(
                            color: Color(0xFF29258F),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          activity.objective ?? activity.description,
                          style: const TextStyle(
                            color: Color(0xFF29258F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.star,
                          title: "Points",
                          value: "${activity.rewardPoints}",
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.timer,
                          title: "Durée",
                          value: "${(activity.duration / 60).ceil()} min",
                        ),
                      ),
                    ],
                  ),

                  // --- PROGRESSION : uniquement en mode enfant. Le parent
                  // n'a besoin ni de la voir ni de la comprendre (point 1).
                  if (modeJouable) ...[
                    const SizedBox(height: 30),
                    Consumer(
                      builder: (context, ref, _) {
                        final progressionAsync = ref.watch(
                          activiteProgressMapProvider(enfantId!),
                        );
                        return progressionAsync.when(
                          data: (progressions) {
                            final progress = progressions[activity.activityId];
                            final valeur = progress?.score ?? 0;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Progression",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: LinearProgressIndicator(
                                    value: (valeur / 100).clamp(0.0, 1.0),
                                    minHeight: 14,
                                    backgroundColor: Colors.grey.shade300,
                                    valueColor: AlwaysStoppedAnimation(
                                      category.accent,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text("${valeur.toInt()} %"),
                              ],
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 40),

                  if (modeJouable)
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          context.pushNamed(
                            AppRoutes.childActivityPlayName,
                            extra: (activity: activity, enfantId: enfantId!),
                          );
                        },
                        child: const Text("Commencer"),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Cette activité est jouable depuis le profil de l'enfant.",
                        textAlign: TextAlign.center,
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

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.deepPurple),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
