class CategorieJouetModel {
  final String categorieId;
  final String nom;
  final String icone;
  final String description;

  const CategorieJouetModel({
    required this.categorieId,
    required this.nom,
    required this.icone,
    required this.description,
  });

  // Créer un CategorieJouetModel à partir d'une Map
  factory CategorieJouetModel.fromMap(Map<String, dynamic> map) {
    return CategorieJouetModel(
      categorieId: map['categorieId'] ?? '',
      nom: map['nom'] ?? '',
      icone: map['icone'] ?? '',
      description: map['description'] ?? '',
    );
  }

  // Transformer le modèle en Map
  Map<String, dynamic> toMap() {
    return {
      'categorieId': categorieId,
      'nom': nom,
      'icone': icone,
      'description': description,
    };
  }

  // Créer un CategorieJouetModel à partir d'un JSON
  factory CategorieJouetModel.fromJson(Map<String, dynamic> json) {
    return CategorieJouetModel.fromMap(json);
  }

  // Transformer le modèle en JSON
  Map<String, dynamic> toJson() {
    return toMap();
  }

  // Créer une copie du modèle avec des valeurs modifiées
  CategorieJouetModel copyWith({
    String? categorieId,
    String? nom,
    String? icone,
    String? description,
  }) {
    return CategorieJouetModel(
      categorieId: categorieId ?? this.categorieId,
      nom: nom ?? this.nom,
      icone: icone ?? this.icone,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'CategorieJouetModel('
        'categorieId: $categorieId, '
        'nom: $nom, '
        'icone: $icone, '
        'description: $description'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is CategorieJouetModel &&
        other.categorieId == categorieId &&
        other.nom == nom &&
        other.icone == icone &&
        other.description == description;
  }

  @override
  int get hashCode {
    return Object.hash(
      categorieId,
      nom,
      icone,
      description,
    );
  }
}