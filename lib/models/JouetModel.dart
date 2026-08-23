class JouetModel {
  final String jouetId;
  final String categorieId;
  final String nom;
  final int ageMin;
  final int ageMax;
  final double prix;
  final int stock;
  final String description;
  final String images;
  final double noteMoyenne;
  final int nombreAvis;
  final DateTime dateAjout;

  const JouetModel({
    required this.jouetId,
    required this.categorieId,
    required this.nom,
    required this.ageMin,
    required this.ageMax,
    required this.prix,
    required this.stock,
    required this.description,
    required this.images,
    required this.noteMoyenne,
    required this.nombreAvis,
    required this.dateAjout,
  });

  // Création à partir des données Firestore
  factory JouetModel.fromMap(Map<String, dynamic> map) {
    return JouetModel(
      jouetId: map['jouet_id'] ?? '',
      categorieId: map['categorie_id'] ?? '',
      nom: map['nom'] ?? '',
      ageMin: map['ageMin'] ?? 0,
      ageMax: map['ageMax'] ?? 0,
      prix: (map['prix'] ?? 0).toDouble(),
      stock: map['stock'] ?? 0,
      description: map['description'] ?? '',
      images: map['images'] ?? '',
      noteMoyenne: (map['noteMoyenne'] ?? 0).toDouble(),
      nombreAvis: map['nombreAvis'] ?? 0,
      dateAjout: DateTime.parse(
        map['dateAjout'] ?? '2026-01-01',
      ),
    );
  }

  // Transformation vers une Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'jouet_id': jouetId,
      'categorie_id': categorieId,
      'nom': nom,
      'ageMin': ageMin,
      'ageMax': ageMax,
      'prix': prix,
      'stock': stock,
      'description': description,
      'images': images,
      'noteMoyenne': noteMoyenne,
      'nombreAvis': nombreAvis,
      'dateAjout': dateAjout.toIso8601String(),
    };
  }

  // Création depuis JSON
  factory JouetModel.fromJson(Map<String, dynamic> json) {
    return JouetModel.fromMap(json);
  }

  // Transformation vers JSON
  Map<String, dynamic> toJson() {
    return toMap();
  }

  // Création d'une copie modifiée
  JouetModel copyWith({
    String? jouetId,
    String? categorieId,
    String? nom,
    int? ageMin,
    int? ageMax,
    double? prix,
    int? stock,
    String? description,
    String? images,
    double? noteMoyenne,
    int? nombreAvis,
    DateTime? dateAjout,
  }) {
    return JouetModel(
      jouetId: jouetId ?? this.jouetId,
      categorieId: categorieId ?? this.categorieId,
      nom: nom ?? this.nom,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      prix: prix ?? this.prix,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      images: images ?? this.images,
      noteMoyenne: noteMoyenne ?? this.noteMoyenne,
      nombreAvis: nombreAvis ?? this.nombreAvis,
      dateAjout: dateAjout ?? this.dateAjout,
    );
  }

  @override
  String toString() {
    return 'JouetModel('
        'jouetId: $jouetId, '
        'categorieId: $categorieId, '
        'nom: $nom, '
        'ageMin: $ageMin, '
        'ageMax: $ageMax, '
        'prix: $prix, '
        'stock: $stock, '
        'description: $description, '
        'images: $images, '
        'noteMoyenne: $noteMoyenne, '
        'nombreAvis: $nombreAvis, '
        'dateAjout: $dateAjout'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is JouetModel &&
        other.jouetId == jouetId &&
        other.categorieId == categorieId &&
        other.nom == nom &&
        other.ageMin == ageMin &&
        other.ageMax == ageMax &&
        other.prix == prix &&
        other.stock == stock &&
        other.description == description &&
        other.images == images &&
        other.noteMoyenne == noteMoyenne &&
        other.nombreAvis == nombreAvis &&
        other.dateAjout == dateAjout;
  }

  @override
  int get hashCode {
    return Object.hash(
      jouetId,
      categorieId,
      nom,
      ageMin,
      ageMax,
      prix,
      stock,
      description,
      images,
      noteMoyenne,
      nombreAvis,
      dateAjout,
    );
  }
}