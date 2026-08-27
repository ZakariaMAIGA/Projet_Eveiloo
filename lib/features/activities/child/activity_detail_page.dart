import 'package:flutter/material.dart';

import '../../../models/activity_model.dart';
import '../widgets/activity_category.dart';
import 'activity_play_page.dart';

class ActivityDetailPage extends StatelessWidget {
  final ActivityModel activity;

  const ActivityDetailPage({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    final category = categoryStyle(activity.competenceCategory);
    final progress = (activity.progress / 100).clamp(0.0, 1.0);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF29258F), size: 32),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border, color: Color(0xFF29258F), size: 30),
          ),
        ],
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
                              child: Icon(Icons.broken_image_outlined,
                                  color: Color(0xFFE91E9B), size: 52),
                            ),
                          )
                        : const ColoredBox(
                            color: Color(0xFFFFE4F0),
                            child: Icon(Icons.menu_book_rounded,
                                color: Color(0xFFE91E9B), size: 52),
                          ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    activity.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF29258F),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                 
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
                        const Text('Objectif', style: TextStyle(
                          color: Color(0xFF29258F),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        )),
                        const SizedBox(height: 12),
                        Text(activity.objective ?? activity.description,
                            style: const TextStyle(
                              color: Color(0xFF29258F),
                              fontWeight: FontWeight.w600,
                            )),
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
                            value:
                              "${activity.rewardPoints}",
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: _InfoCard(
                          icon: Icons.timer,
                          title: "Durée",
                            value:
                              "${(activity.duration / 60).ceil()} min",
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Progression",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 14,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation(category.accent),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${activity.progress.toInt()} %",
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ActivityPlayPage(
                              activity: activity,
                            ),
                          ),
                        );

                      },
                      child: const Text(
                        "Commencer",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )

                ],
              ),
            )

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

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            Icon(
              icon,
              size: 35,
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
              ),
            )

          ],

        ),
      ),
    );
  }
}