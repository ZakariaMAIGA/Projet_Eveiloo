import 'package:cloud_firestore/cloud_firestore.dart';

class JournalProgresModel {
  final String journalId;
  final String utilisateurId;
  final String enfantId;
  final String elementId;
  final String typeElement;
  final String titre;
  final double score;
  final int dureeSecondes;
  final int pointsGagnes;
  final DateTime dateRealisation;

  JournalProgresModel({
    required this.journalId,
    required this.utilisateurId,
    required this.enfantId,
    required this.elementId,
    required this.typeElement,
    required this.titre,
    required this.score,
    required this.dureeSecondes,
    required this.pointsGagnes,
    required this.dateRealisation,
  });

  factory JournalProgresModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return JournalProgresModel(
      journalId: doc.id,
      utilisateurId: data['utilisateurId'] ?? '',
      enfantId: data['enfantId'] ?? '',
      elementId: data['elementId'] ?? '',
      typeElement: data['typeElement'] ?? '',
      titre: data['titre'] ?? '',
      score: (data['score'] ?? 0).toDouble(),
      dureeSecondes: data['dureeSecondes'] ?? 0,
      pointsGagnes: data['pointsGagnes'] ?? 0,
      dateRealisation:
          (data['dateRealisation'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'utilisateurId': utilisateurId,
      'enfantId': enfantId,
      'elementId': elementId,
      'typeElement': typeElement,
      'titre': titre,
      'score': score,
      'dureeSecondes': dureeSecondes,
      'pointsGagnes': pointsGagnes,
      'dateRealisation': Timestamp.fromDate(dateRealisation),
    };
  }
}