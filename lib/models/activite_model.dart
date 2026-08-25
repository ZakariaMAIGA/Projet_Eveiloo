class Activite {
  final String activiteId;
  final String titre;
  final String description;
  final String typeActivite;
  final int ageMin;
  final int  ageMax;
  final String categorieCompetence;
  final int pointRecompense;
  final String seuilReussite;
  final String dateTime;

  Activite(
{
  required this.activiteId,
  required this.titre,
   required this.description,
    required this.typeActivite,
    required this.ageMin,
    required this.ageMax,
    required this.categorieCompetence,
    required this.pointRecompense,
    required this.seuilReussite,
    required this.dateTime,
    
}
  );


  // Transformer un document Firestore en objet Activite
  factory Activite.fromJson(Map<String, dynamic> json, String id) {
    return Activite(
      activiteId: json ['activiteId']??'',
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      typeActivite: json['typeActivite'] ?? '',
      ageMax: json['ageMax'] ?? 0,
      ageMin: json['ageMin'] ?? 0,
      categorieCompetence: json['categorieCompetence'] ?? '',
      pointRecompense: json['pointRecompense'] ?? '',
      seuilReussite: json['seuilReussite'] ?? '',
      dateTime: json['dateTime'] ?? 0,
    );
  }

  // Transformer l'objet Activite en Map pour Firestore
  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'description': description,
      'typeActivite': typeActivite,
      'ageMin': ageMin,
      'ageMax': ageMax,
      'categorieCompetence': categorieCompetence,
      'pointRecompense': pointRecompense,
      'seuilReussite': seuilReussite,
      'dateTime': dateTime,
    };
  }
}

