import 'package:cloud_firestore/cloud_firestore.dart';

/// Type d'élément suivi dans le journal (activité ou tutoriel).
enum TypeElementProgres {
  activite,
  tutoriel;

  static TypeElementProgres fromString(String? value) {
    switch (value) {
      case 'tutoriel':
        return TypeElementProgres.tutoriel;
      case 'activite':
      default:
        return TypeElementProgres.activite;
    }
  }

  String toValue() => name;
}

class JournalProgresModel {
  final String journalId;
  final String utilisateurId;
  final String enfantId;
  final String elementId;
  final TypeElementProgres typeElement;
  final String titre;
  final double score;
  final int dureeSecondes;
  final int pointsGagnes;
  final DateTime? dateRealisation;

  const JournalProgresModel({
    required this.journalId,
    required this.utilisateurId,
    required this.enfantId,
    required this.elementId,
    required this.typeElement,
    required this.titre,
    this.score = 0,
    this.dureeSecondes = 0,
    this.pointsGagnes = 0,
    this.dateRealisation,
  });

  factory JournalProgresModel.fromMap(Map<String, dynamic> map, String id) {
    return JournalProgresModel(
      journalId: id,
      utilisateurId: map['utilisateurId'] ?? '',
      enfantId: map['enfantId'] ?? '',
      elementId: map['elementId'] ?? '',
      typeElement: TypeElementProgres.fromString(map['typeElement'] as String?),
      titre: map['titre'] ?? '',
      score: (map['score'] ?? 0).toDouble(),
      dureeSecondes: (map['dureeSecondes'] ?? 0) as int,
      pointsGagnes: (map['pointsGagnes'] ?? 0) as int,
      dateRealisation: (map['dateRealisation'] as Timestamp?)?.toDate(),
    );
  }

  factory JournalProgresModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return JournalProgresModel.fromMap(doc.data() ?? {}, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'utilisateurId': utilisateurId,
      'enfantId': enfantId,
      'elementId': elementId,
      'typeElement': typeElement.toValue(),
      'titre': titre,
      'score': score,
      'dureeSecondes': dureeSecondes,
      'pointsGagnes': pointsGagnes,
      'dateRealisation': dateRealisation != null
          ? Timestamp.fromDate(dateRealisation!)
          : FieldValue.serverTimestamp(),
    };
  }

  JournalProgresModel copyWith({
    String? journalId,
    String? utilisateurId,
    String? enfantId,
    String? elementId,
    TypeElementProgres? typeElement,
    String? titre,
    double? score,
    int? dureeSecondes,
    int? pointsGagnes,
    DateTime? dateRealisation,
  }) {
    return JournalProgresModel(
      journalId: journalId ?? this.journalId,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      enfantId: enfantId ?? this.enfantId,
      elementId: elementId ?? this.elementId,
      typeElement: typeElement ?? this.typeElement,
      titre: titre ?? this.titre,
      score: score ?? this.score,
      dureeSecondes: dureeSecondes ?? this.dureeSecondes,
      pointsGagnes: pointsGagnes ?? this.pointsGagnes,
      dateRealisation: dateRealisation ?? this.dateRealisation,
    );
  }
}
