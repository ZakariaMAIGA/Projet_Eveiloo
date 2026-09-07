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
  final String ageRange; // ex: "4-6 ans"
  final double note;
  final int nombreAvis;
  final List<String> tags;
  final List<String> competences;

  /// Date d'ajout du jouet (écrite côté serveur via FieldValue.serverTimestamp
  /// dans ToyRepository.addToy). Null pour les jouets ajoutés avant ce champ.
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
    required this.note,
    required this.nombreAvis,
    required this.tags,
    required this.competences,
    this.dateAjout,
  });

  factory ToyModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ToyModel(
      id: id,
      nom: data['nom'] ?? '',
      description: data['description'] ?? '',
      prix: (data['prix'] is num) ? (data['prix'] as num).toDouble() : 0.0,
      imageUrl: data['imageUrl'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      categorieId: data['categorieId'] ?? '',
      genre: data['genre'] ?? 'fille',
      ageRange: data['ageRange'] ?? 'Tous',
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
      'note': note,
      'nombreAvis': nombreAvis,
      'tags': tags,
      'competences': competences,
      // dateAjout n'est PAS inclus ici : il est ajouté côté repository via
      // FieldValue.serverTimestamp() au moment de la création, pas via le
      // modèle (pour garantir une horloge serveur, pas celle du téléphone).
    };
  }
}
