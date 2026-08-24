class Tutoriel {
  final String id;
  final String titre;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final String ageMin;
  final String ageMax;
  final String categorie;
  final String dateCreation;

  Tutoriel({
    required this.id,
    required this.titre,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
    required this.ageMin,
    required this.ageMax,
    required this.categorie,
    required this.dateCreation,
  });

  factory Tutoriel.fromJson(Map<String, dynamic> json) {
    return Tutoriel(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      ageMin: json['ageMin'],
      ageMax: json['ageMax'],
      categorie: json['categorie'],
      dateCreation: json['dateCreation'],
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'ageMin': ageMin,
      'ageMax': ageMax,
      'categorie': categorie,
      'dateCreation': dateCreation,
    };
  }

  Tutoriel copyWith({
    String? id,
    String? titre,
    String? description,
    String? imageUrl,
    String? videoUrl,
    String? ageMin,
    String? ageMax,
    String? categorie,
    String? dateCreation,
  }) {
    return Tutoriel(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      categorie: categorie ?? this.categorie,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }
}