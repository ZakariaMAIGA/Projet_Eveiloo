import 'package:cloud_firestore/cloud_firestore.dart';

class TutorielModel {
  final String tutorielId;
  final String titre;
  final String description;
  final String urlVideo;
  final String urlImage;
  final int ageMin;
  final int ageMax;
  final String categorie;
  final DateTime dateCreation;
  final List<String> materielIds; // Liste simple des IDs des jouets

  TutorielModel({
    required this.tutorielId,
    required this.titre,
    this.description = '',
    this.urlVideo = '',
    this.urlImage = '',
    this.ageMin = 0,
    this.ageMax = 0,
    required this.categorie,
    DateTime? dateCreation,
    this.materielIds = const [],
  }) : dateCreation = dateCreation ?? DateTime.now();

  factory TutorielModel.fromMap(Map<String, dynamic> map, String id) {
    return TutorielModel(
      tutorielId: id,
      titre: map['titre'] ?? '',
      description: map['description'] ?? '',
      urlVideo: map['urlVideo'] ?? '',
      urlImage: map['urlImage'] ?? '',
      ageMin: (map['ageMin'] as num?)?.toInt() ?? 0,
      ageMax: (map['ageMax'] as num?)?.toInt() ?? 0,
      categorie: map['categorie'] ?? '',
      dateCreation:
          (map['dateCreation'] as Timestamp?)?.toDate() ?? DateTime.now(),
      materielIds: List<String>.from(map['materiels'] ?? []),
    );
  }

  factory TutorielModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return TutorielModel.fromMap(doc.data() ?? {}, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'urlVideo': urlVideo,
      'urlImage': urlImage,
      'ageMin': ageMin,
      'ageMax': ageMax,
      'categorie': categorie,
      'dateCreation': Timestamp.fromDate(dateCreation),
      'materiels':
          materielIds, // On enregistre juste un tableau d'IDs (ex: ["toy_001", "toy_002"])
    };
  }
}
