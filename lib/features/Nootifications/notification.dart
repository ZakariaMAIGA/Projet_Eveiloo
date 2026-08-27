// features/Nootifications/notification.dart
import 'package:eveiloo_enfant/core/provider/notification_service_provider.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/AppFontSize.dart';
import '../../core/constants/AppSpacing.dart';

import '../../models/notifications.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Accès au service via Riverpod
    final notificationService = ref.watch(notificationServiceProvider);
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: AppFontSize.semiLarge),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Notification>>(
        stream: notificationService.getNotification(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur: ${snapshot.error}',
                style: const TextStyle(fontSize: AppFontSize.small),
              ),
            );
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                'Aucune notification pour le moment.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: AppFontSize.medium,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            padding: const EdgeInsets.all(AppSpacing.md),
            itemBuilder: (context, index) {
              final item = notifications[index];
              final isTutoriel = item.type == 'tutoriel';

              return Card(
                elevation: item.lu ? 1 : 3,
                color: item.lu ? Colors.grey.shade100 : Colors.white,
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isTutoriel
                        ? Colors.deepOrange.shade100
                        : Colors.blue.shade100,
                    child: Icon(
                      isTutoriel ? Icons.school : Icons.article,
                      color: isTutoriel ? Colors.deepOrange : Colors.blue,
                    ),
                  ),
                  title: Text(
                    item.titre,
                    style: TextStyle(
                      fontSize: AppFontSize.medium,
                      fontWeight: item.lu ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacing.verticalGapXs,
                      Text(
                        item.message,
                        style: const TextStyle(fontSize: AppFontSize.small),
                      ),
                      AppSpacing.verticalGapSm,
                      Text(
                        '${item.dateEnvoi.day}/${item.dateEnvoi.month}/${item.dateEnvoi.year} à ${item.dateEnvoi.hour}h${item.dateEnvoi.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: AppFontSize.caption,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (!item.lu) {
                      notificationService.marquerCommeLue(item.idNotification);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
