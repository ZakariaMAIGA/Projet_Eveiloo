import 'package:flutter/material.dart';

import '../../../models/activity_model.dart';
import 'activity_play_page.dart';

class ActivityDetailPage extends StatelessWidget {
  final ActivityModel activity;

  const ActivityDetailPage({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.title),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Hero(
              tag: activity.activityId,
              child: activity.imageUrl != null
                  ? Image.network(
                      activity.imageUrl!,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
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
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    activity.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Objectif",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(activity.objective ?? 'Non spécifié'),

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
                              "${activity.duration} min",
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
                      value: activity.progress / 100,
                      minHeight: 12,
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
                          fontSize: 18,
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