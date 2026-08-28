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
  final DateTime? dateCreation;

  const TutorielModel({
    required this.tutorielId,
    required this.titre,
    this.description = '',
    this.urlVideo = '',
    this.urlImage = '',
    this.ageMin = 0,
    this.ageMax = 0,
    this.categorie = '',
    this.dateCreation,
  });

  factory TutorielModel.fromMap(Map<String, dynamic> map, String id) {
    return TutorielModel(
      tutorielId: id,
      titre: map['titre'] ?? '',
      description: map['description'] ?? '',
      urlVideo: map['urlVideo'] ?? '',
      urlImage: map['urlImage'] ?? '',
      ageMin: (map['ageMin'] ?? 0) as int,
      ageMax: (map['ageMax'] ?? 0) as int,
      categorie: map['categorie'] ?? '',
      dateCreation: (map['dateCreation'] as Timestamp?)?.toDate(),
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
      'dateCreation': dateCreation != null
          ? Timestamp.fromDate(dateCreation!)
          : FieldValue.serverTimestamp(),
    };
  }

  TutorielModel copyWith({
    String? tutorielId,
    String? titre,
    String? description,
    String? urlVideo,
    String? urlImage,
    int? ageMin,
    int? ageMax,
    String? categorie,
    DateTime? dateCreation,
  }) {
    return TutorielModel(
      tutorielId: tutorielId ?? this.tutorielId,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      urlVideo: urlVideo ?? this.urlVideo,
      urlImage: urlImage ?? this.urlImage,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      categorie: categorie ?? this.categorie,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }
}
