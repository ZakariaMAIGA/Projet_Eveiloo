import 'package:cloud_firestore/cloud_firestore.dart';

class JournalProgresModel {
  final String journalId;
  final String utilisateurId;
  final String enfantId;
  final String elementId;
  final String typeElement; // 'activite' | 'tutoriel'
  final String titre;
  final double score;
  final double dureeSecondes;
  final int pointsGagnes;
  final DateTime dateRealisation;

  JournalProgresModel({
    required this.journalId,
    required this.utilisateurId,
    required this.enfantId,
    required this.elementId,
    required this.typeElement,
    required this.titre,
    this.score = 0,
    this.dureeSecondes = 0,
    this.pointsGagnes = 0,
    required this.dateRealisation,
  });

  factory JournalProgresModel.fromMap(Map<String, dynamic> map, String id) {
    return JournalProgresModel(
      journalId: id,
      utilisateurId: map['utilisateurId'] ?? '',
      enfantId: map['enfantId'] ?? '',
      elementId: map['elementId'] ?? '',
      typeElement: map['typeElement'] ?? '',
      titre: map['titre'] ?? '',
      score: (map['score'] ?? 0).toDouble(),
      dureeSecondes: (map['dureeSecondes'] ?? 0).toDouble(),
      pointsGagnes: map['pointsGagnes'] ?? 0,
      dateRealisation: (map['dateRealisation'] as Timestamp).toDate(),
    );
  }

  factory JournalProgresModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JournalProgresModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
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
