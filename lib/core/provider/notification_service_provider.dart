// core/services/notification_service_provider.dart
import 'package:eveiloo_enfant/core/services/notificationService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final notificationServiceProvider = ChangeNotifierProvider<NotificationService>(
  (ref) {
    final service = NotificationService();

    service.initNotifications().catchError((e) {
      debugPrint('Erreur initNotifications: $e');
    });

    return service;
  },
);
