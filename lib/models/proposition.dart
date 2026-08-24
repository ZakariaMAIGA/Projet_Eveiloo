class Proposition {
  final String id;
  final String texte;
  final String? imageUrl;

  const Proposition({
    required this.id,
    required this.texte,
    this.imageUrl,
  });

  /// Crée une [Proposition] à partir d'une Map (ex: document Firestore).
  factory Proposition.fromMap(Map<String, dynamic> map) {
    return Proposition(
      id: map['id']?.toString() ?? '',
      texte: map['texte']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString(),
    );
  }

  /// Convertit la [Proposition] en Map (pour Firestore ou tout autre backend JSON).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'texte': texte,
      'imageUrl': imageUrl,
    };
  }

  /// Retourne une copie de la proposition avec certains champs modifiés.
  Proposition copyWith({
    String? id,
    String? texte,
    String? imageUrl,
  }) {
    return Proposition(
      id: id ?? this.id,
      texte: texte ?? this.texte,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Proposition &&
        other.id == id &&
        other.texte == texte &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => id.hashCode ^ texte.hashCode ^ imageUrl.hashCode;

  @override
  String toString() => 'Proposition(id: $id, texte: $texte, imageUrl: $imageUrl)';
}
