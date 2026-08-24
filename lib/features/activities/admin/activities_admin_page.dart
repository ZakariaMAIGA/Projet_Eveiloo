import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/activity_model.dart';
import '../providers/activity_provider.dart';
import 'add_activity_page.dart';
import 'edit_activity_page.dart';
import 'questions_admin_page.dart';

class ActivitiesAdminPage extends ConsumerWidget {
  const ActivitiesAdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des activités"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddActivityPage(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Nouvelle activité"),
      ),

      body: activities.when(
        data: (activities) {
          if (activities.isEmpty) {
            return const Center(
              child: Text(
                "Aucune activité disponible",
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];

              return _ActivityCard(activity: activity);
            },
          );
        },

        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, s) => Center(
          child: Text(e.toString()),
        ),
      ),
    );
  }
}

class _ActivityCard extends ConsumerWidget {
  final ActivityModel activity;

  const _ActivityCard({
    required this.activity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              activity.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(activity.description),

            const SizedBox(height: 15),

            Row(
              children: [

                Chip(
                  label: Text(
                    "${activity.minAge} - ${activity.maxAge} ans",
                  ),
                ),

                const SizedBox(width: 10),

                Chip(
                  label: Text(
                    "${activity.rewardPoints} pts",
                  ),
                ),
              ],
            ),

            const Divider(),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [

                TextButton.icon(
                  icon: const Icon(Icons.quiz),
                  label: const Text("Questions"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuestionsAdminPage(
                          activity: activity,
                        ),
                      ),
                    );
                  },
                ),

                TextButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Modifier"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditActivityPage(
                          activity: activity,
                        ),
                      ),
                    );
                  },
                ),

                TextButton.icon(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  label: const Text(
                    "Supprimer",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () async {

                    final confirm =
                        await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text(
                          "Confirmation",
                        ),
                        content: const Text(
                          "Supprimer cette activité ?",
                        ),
                        actions: [

                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                  context,
                                  false);
                            },
                            child: const Text("Non"),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                  context,
                                  true);
                            },
                            child: const Text("Oui"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await ref
                          .read(activityServiceProvider)
                          .deleteActivity(
                            activity.activityId,
                          );
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}