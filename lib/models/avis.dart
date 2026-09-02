import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle représentant l'avis d'un utilisateur sur un jouet.
class AvisModel {
  final String avisId;
  final String jouetId;
  final String utilisateurId;
  final int note;
  final String commentaire;
  final DateTime date;

  AvisModel({
    required this.avisId,
    required this.jouetId,
    required this.utilisateurId,
    required this.note,
    this.commentaire = '',
    required this.date,
  });

  factory AvisModel.fromMap(Map<String, dynamic> map, String id) {
    return AvisModel(
      avisId: id,
      jouetId: map['jouetId'] ?? '',
      utilisateurId: map['utilisateurId'] ?? '',
      note: map['note'] ?? 0,
      commentaire: map['commentaire'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  factory AvisModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AvisModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'jouetId': jouetId,
      'utilisateurId': utilisateurId,
      'note': note,
      'commentaire': commentaire,
      'date': Timestamp.fromDate(date),
    };
  }

  AvisModel copyWith({
    String? jouetId,
    String? utilisateurId,
    int? note,
    String? commentaire,
    DateTime? date,
  }) {
    return AvisModel(
      avisId: avisId,
      jouetId: jouetId ?? this.jouetId,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      note: note ?? this.note,
      commentaire: commentaire ?? this.commentaire,
      date: date ?? this.date,
    );
  }
}
