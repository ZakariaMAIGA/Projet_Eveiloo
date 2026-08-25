class ToyModel {
  final String id;
  final String nom;
  final String description;
  final double prix;
  final String imageUrl;
  final List<String> images;
  final String categorieId; // <-- Champ ajouté
  final String genre; // "fille" ou "garcon"
  final String ageRange; // ex: "4-6 ans"
  final double note;
  final int nombreAvis;
  final List<String> tags;
  final List<String> competences;

  ToyModel({
    required this.id,
    required this.nom,
    required this.description,
    required this.prix,
    required this.imageUrl,
    required this.images,
    required this.categorieId, // <-- Requis dans le constructeur
    required this.genre,
    required this.ageRange,
    required this.note,
    required this.nombreAvis,
    required this.tags,
    required this.competences,
  });

  factory ToyModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ToyModel(
      id: id,
      nom: data['nom'] ?? '',
      description: data['description'] ?? '',
      prix: (data['prix'] is num) ? (data['prix'] as num).toDouble() : 0.0,
      imageUrl: data['imageUrl'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      categorieId: data['categorieId'] ?? '', // <-- Extraction depuis Firestore
      genre: data['genre'] ?? 'fille',
      ageRange: data['ageRange'] ?? 'Tous',
      note: (data['note'] is num) ? (data['note'] as num).toDouble() : 0.0,
      nombreAvis: (data['nombreAvis'] is num) ? (data['nombreAvis'] as int) : 0,
      tags: List<String>.from(data['tags'] ?? []),
      competences: List<String>.from(data['competences'] ?? []),
    );
  }

  // Optionnel mais très utile pour réécrire dans Firestore :
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
    };
  }
}
