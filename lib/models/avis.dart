import 'package:cloud_firestore/cloud_firestore.dart';

class AvisModel {
  final String avisId;
  final String jouetId;
  final String utilisateurId;
  final int note;
  final String commentaire;
  final DateTime? date;

  const AvisModel({
    required this.avisId,
    required this.jouetId,
    required this.utilisateurId,
    required this.note,
    this.commentaire = '',
    this.date,
  });

  factory AvisModel.fromMap(Map<String, dynamic> map, String id) {
    return AvisModel(
      avisId: id,
      jouetId: map['jouetId'] ?? '',
      utilisateurId: map['utilisateurId'] ?? '',
      note: (map['note'] ?? 0) as int,
      commentaire: map['commentaire'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate(),
    );
  }

  factory AvisModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return AvisModel.fromMap(doc.data() ?? {}, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'jouetId': jouetId,
      'utilisateurId': utilisateurId,
      'note': note,
      'commentaire': commentaire,
      'date': date != null
          ? Timestamp.fromDate(date!)
          : FieldValue.serverTimestamp(),
    };
  }

  AvisModel copyWith({
    String? avisId,
    String? jouetId,
    String? utilisateurId,
    int? note,
    String? commentaire,
    DateTime? date,
  }) {
    return AvisModel(
      avisId: avisId ?? this.avisId,
      jouetId: jouetId ?? this.jouetId,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      note: note ?? this.note,
      commentaire: commentaire ?? this.commentaire,
      date: date ?? this.date,
    );
  }
}
