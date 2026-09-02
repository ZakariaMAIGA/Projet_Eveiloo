import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  final String articlePanierId;
  final String jouetId;
  final String nom;
  final double prixUnitaire;
  final int quantite;
  final String urlImage;

  const CartItemModel({
    required this.articlePanierId,
    required this.jouetId,
    required this.nom,
    required this.prixUnitaire,
    this.quantite = 1,
    this.urlImage = '',
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map, String id) {
    return CartItemModel(
      articlePanierId: id,
      jouetId: map['jouetId'] ?? '',
      nom: map['nom'] ?? '',
      prixUnitaire: (map['prixUnitaire'] ?? 0).toDouble(),
      quantite: (map['quantite'] ?? 1) as int,
      urlImage: map['urlImage'] ?? '',
    );
  }

  factory CartItemModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return CartItemModel.fromMap(doc.data() ?? {}, doc.id);
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

  CartItemModel copyWith({
    String? articlePanierId,
    String? jouetId,
    String? nom,
    double? prixUnitaire,
    int? quantite,
    String? urlImage,
  }) {
    return CartItemModel(
      articlePanierId: articlePanierId ?? this.articlePanierId,
      jouetId: jouetId ?? this.jouetId,
      nom: nom ?? this.nom,
      prixUnitaire: prixUnitaire ?? this.prixUnitaire,
      quantite: quantite ?? this.quantite,
      urlImage: urlImage ?? this.urlImage,
    );
  }
}
