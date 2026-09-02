import 'package:cloud_firestore/cloud_firestore.dart';

class CommandeArticleModel {
  final String commandeArticleId;
  final String jouetId;
  final String nom;
  final double prixUnitaire;
  final int quantite;
  final String urlImage;

  const CommandeArticleModel({
    required this.commandeArticleId,
    required this.jouetId,
    required this.nom,
    required this.prixUnitaire,
    required this.quantite,
    this.urlImage = '',
  });

  factory CommandeArticleModel.fromMap(Map<String, dynamic> map, String id) {
    return CommandeArticleModel(
      commandeArticleId: id,
      jouetId: map['jouetId'] ?? '',
      nom: map['nom'] ?? '',
      prixUnitaire: (map['prixUnitaire'] ?? 0).toDouble(),
      quantite: (map['quantite'] ?? 1) as int,
      urlImage: map['urlImage'] ?? '',
    );
  }

  factory CommandeArticleModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return CommandeArticleModel.fromMap(doc.data() ?? {}, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'jouetId': jouetId,
      'nom': nom,
      'prixUnitaire': prixUnitaire,
      'quantite': quantite,
      'urlImage': urlImage,
    };
  }

  double get sousTotal => prixUnitaire * quantite;
}
