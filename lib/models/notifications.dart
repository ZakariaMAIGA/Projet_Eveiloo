import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String idNotification;
  final String idUtilisateur;
  final String titre;
  final String message;
  final String type;
  final bool lu;
  final DateTime dateEnvoi;

  Notification({
    required this.idNotification,
    required this.idUtilisateur,
    required this.titre,
    required this.message,
    required this.type,
    this.lu = false,
    required this.dateEnvoi,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      idNotification: json['idNotification'].toString(),
      idUtilisateur: json['idUtilisateur'].toString(),
      titre: json['titre'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      lu: json['lu'] as bool? ?? false,
      dateEnvoi: DateTime.parse(json['dateEnvoi'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idNotification': idNotification,
      'idUtilisateur': idUtilisateur,
      'titre': titre,
      'message': message,
      'type': type,
      'lu': lu,
      'dateEnvoi': dateEnvoi.toIso8601String(),
    };
  }


  factory Notification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Notification(
      idNotification: doc.id,
      idUtilisateur: data['idUtilisateur'] as String,
      titre: data['titre'] as String,
      message: data['message'] as String,
      type: data['type'] as String,
      lu: data['lu'] as bool? ?? false,
      dateEnvoi: (data['dateEnvoi'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'idUtilisateur': idUtilisateur,
      'titre': titre,
      'message': message,
      'type': type,
      'lu': lu,
      'dateEnvoi': Timestamp.fromDate(dateEnvoi),
    };
  }
}