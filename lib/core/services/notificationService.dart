import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as dev;
import '../../models/notifications.dart';

class NotificationService extends ChangeNotifier {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialisation de FCM (Abonnements + Enregistrement Firestore à la réception)
  Future<void> initNotifications() async {
    // 1. Demande de permission
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Affichage du token FCM pour tes tests
      String? token = await _fcm.getToken();
      if (kDebugMode) {
        dev.log("========================================");
        dev.log("FCM TOKEN : $token");
        dev.log("========================================");
      }

      

      // 2. Abonnement aux thèmes
      await _fcm.subscribeToTopic('nouveau_tutoriel');
      await _fcm.subscribeToTopic('nouvel_article');

      // 3. Écoute en direct des messages FCM + SAUVEGARDE FIRESTORE
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        if (kDebugMode) {
          print('Notification FCM reçue : ${message.notification?.title}');
        }

        // Si la notification contient un titre/message, on l'ajoute à Firestore
        if (message.notification != null) {
          await _sauvegarderNotificationFCM(
            titre: message.notification!.title ?? '',
            message: message.notification!.body ?? '',
            type: message.data['type'] ?? 'tutoriel',
          );
        }

        notifyListeners();
      });
    }
  }

  // Enregistre automatiquement la notification FCM reçue dans la BDD Firestore
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
      if (kDebugMode) {
        print("Erreur lors de la sauvegarde Firestore : $e");
      }
    }
  }

  // Écouter les notifications Firestore en TEMPS RÉEL (avec tri local en Dart)
  Stream<List<Notification>> getNotification(String idUtilisateur) {
    return _firestore
        .collection('notification')
        .where('idUtilisateur', whereIn: [idUtilisateur, 'TOUS'])
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => Notification.fromFirestore(doc))
              .toList();

          // Tri local par date décroissante
          list.sort((a, b) => b.dateEnvoi.compareTo(a.dateEnvoi));
          return list;
        });
  }

  // Marquer une notification comme lue dans Firestore
  Future<void> marquerCommeLue(String idNotification) async {
    try {
      await _firestore
          .collection('notification')
          .doc(idNotification)
          .update({'lu': true});
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la mise à jour 'lu' : $e");
      }
    }
  }
}