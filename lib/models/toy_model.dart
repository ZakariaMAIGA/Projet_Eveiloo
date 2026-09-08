import 'package:cloud_firestore/cloud_firestore.dart';

class ToyModel {
  final String id;
  final String nom;
  final String description;
  final double prix;
  final String imageUrl;
  final List<String> images;
  final String categorieId;
  final String genre; // "fille" ou "garcon"
  final String ageRange; // ex: "4-6 ans", "7-10 ans"
  final int ageMin;
  final int ageMax;
  final double note;
  final int nombreAvis;
  final List<String> tags;
  final List<String> competences;
  final DateTime? dateAjout;

  ToyModel({
    required this.id,
    required this.nom,
    required this.description,
    required this.prix,
    required this.imageUrl,
    required this.images,
    required this.categorieId,
    required this.genre,
    required this.ageRange,
    required this.ageMin,
    required this.ageMax,
    required this.note,
    required this.nombreAvis,
    required this.tags,
    required this.competences,
    this.dateAjout,
  });

  factory ToyModel.fromFirestore(Map<String, dynamic> data, String id) {
    int min = data['ageMin'] ?? 4;
    int max = data['ageMax'] ?? 14;

    // Parser automatique si ageMin/ageMax ne sont pas définis explicitement
    if (data['ageMin'] == null && data['ageRange'] != null) {
      final rangeStr = data['ageRange'].toString();
      if (rangeStr.toLowerCase() == 'tous') {
        min = 4;
        max = 14;
      } else {
        final numbers = RegExp(r'\d+').allMatches(rangeStr);
        final list = numbers.map((m) => int.parse(m.group(0)!)).toList();
        if (list.length >= 2) {
          min = list.first;
          max = list.last;
        } else if (list.length == 1) {
          min = list.first;
          max = 14;
        }
      }
    }

    return ToyModel(
      id: id,
      nom: data['nom'] ?? '',
      description: data['description'] ?? '',
      prix: (data['prix'] is num) ? (data['prix'] as num).toDouble() : 0.0,
      imageUrl: data['imageUrl'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      categorieId: data['categorieId'] ?? '',
      genre: data['genre'] ?? 'fille',
      ageRange: data['ageRange'] ?? '4-14 ans',
      ageMin: min,
      ageMax: max,
      note: (data['note'] is num) ? (data['note'] as num).toDouble() : 0.0,
      nombreAvis: (data['nombreAvis'] is num) ? (data['nombreAvis'] as int) : 0,
      tags: List<String>.from(data['tags'] ?? []),
      competences: List<String>.from(data['competences'] ?? []),
      dateAjout: (data['dateAjout'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'description': description,
      'prix': prix,
      'imageUrl': imageUrl,
      'images': images,
      'categorieId': categorieId,
      'genre': genre,
      'ageRange': ageRange,
      'ageMin': ageMin,
      'ageMax': ageMax,
      'note': note,
      'nombreAvis': nombreAvis,
      'tags': tags,
      'competences': competences,
    };
  }
}
