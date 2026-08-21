import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String avisId;        // PK
  final String jouetId;       // FK
  final String utilisateurId; // FK
  final int note;             // int
  final String commentaire;   // string
  final DateTime date;        // timestamp

  ReviewModel({
    required this.avisId,
    required this.jouetId,
    required this.utilisateurId,
    required this.note,
    required this.commentaire,
    required this.date,
  });

  factory ReviewModel.fromFirestore(Map<String, dynamic> json, String id) {
    return ReviewModel(
      avisId: id.isNotEmpty ? id : (json['avisId'] ?? ''),
      jouetId: json['jouetId'] ?? '',
      utilisateurId: json['utilisateurId'] ?? '',
      note: (json['note'] as num?)?.toInt() ?? 0,
      commentaire: json['commentaire'] ?? '',
      date: json['date'] is Timestamp
          ? (json['date'] as Timestamp).toDate()
          : DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'avisId': avisId,
      'jouetId': jouetId,
      'utilisateurId': utilisateurId,
      'note': note,
      'commentaire': commentaire,
      'date': Timestamp.fromDate(date),
    };
  }
}