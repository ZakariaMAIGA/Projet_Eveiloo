class CategoryModel {
  final String categorieId;
  final String nom;
  final String description;
  final String? icone;

  CategoryModel({
    required this.categorieId,
    required this.nom,
    required this.description,
    this.icone,
  });

  // Conversion Firestore -> Objet Dart
  factory CategoryModel.fromFirestore(Map<String, dynamic> json, String id) {
    return CategoryModel(
      categorieId: id,
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      icone: json['icone'],
    );
  }

  // Conversion Objet Dart -> Firestore
  Map<String, dynamic> toFirestore() {
    return {'nom': nom, 'description': description, 'icone': icone};
  }
}
