// core/services/notification_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/notifications.dart';

class NotificationService extends ChangeNotifier {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _initialized = false;

  Future<void> initNotifications() async {
    if (_initialized) return;
    _initialized = true;

    // 1. Demande de permission
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    // 2. Token (optionnel : à logger ou envoyer à ton backend)
    final token = await _fcm.getToken();
    debugPrint('FCM TOKEN : $token');

    // 3. Abonnements aux topics
    await _fcm.subscribeToTopic('nouveau_tutoriel');
    await _fcm.subscribeToTopic('nouvel_article');

    // 4. Écoute des messages en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Notification FCM reçue : ${message.notification?.title}');

      if (message.notification != null) {
        await _sauvegarderNotificationFCM(
          titre: message.notification!.title ?? '',
          message: message.notification!.body ?? '',
          type: message.data['type'] ?? 'tutoriel',
        );
      }

      notifyListeners();
    });

    // (Optionnel) Gérer onMessageOpenedApp / onBackgroundMessage si besoin
  }

  Future<void> _sauvegarderNotificationFCM({
    required String titre,
    required String message,
    required String type,
  }) async {
    try {
      await _firestore.collection('notification').add({
        'idUtilisateur': 'TOUS',
        'titre': titre,
        'message': message,
        'type': type,
        'lu': false,
        'dateEnvoi': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde Firestore : $e');
    }
  }

  Stream<List<Notification>> getNotification(String idUtilisateur) {
    return _firestore
        .collection('notification')
        .where('idUtilisateur', whereIn: [idUtilisateur, 'TOUS'])
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => Notification.fromFirestore(doc))
              .toList();

          list.sort((a, b) => b.dateEnvoi.compareTo(a.dateEnvoi));
          return list;
        });
  }

  Future<void> marquerCommeLue(String idNotification) async {
    try {
      await _firestore.collection('notification').doc(idNotification).update({
        'lu': true,
      });
    } catch (e) {
      debugPrint("Erreur lors de la mise à jour 'lu' : $e");
    }
  }
}
