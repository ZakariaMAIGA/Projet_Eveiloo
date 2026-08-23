
class CartItemModel {
  final String articlePanierId;
  final String jouetId;        
  final String nom;             
  final double prixUnitaire; 
  int quantite;               
  final String urlImage;        

  CartItemModel({
    required this.articlePanierId,
    required this.jouetId,
    required this.nom,
    required this.prixUnitaire,
    required this.quantite,
    required this.urlImage,
  });

  // Calcul du prix total pour cet article
  double get totalArticle => prixUnitaire * quantite;

  factory CartItemModel.fromFirestore(Map<String, dynamic> json, String id, List<String> ids) {
    return CartItemModel(
      articlePanierId: id.isNotEmpty ? id : (json['articlePanierId'] ?? ''),
      jouetId: json['jouetId'] ?? '',
      nom: json['nom'] ?? '',
      prixUnitaire: (json['prixUnitaire'] as num?)?.toDouble() ?? 0.0,
      quantite: (json['quantite'] as num?)?.toInt() ?? 1,
      urlImage: json['urlImage'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'articlePanierId': articlePanierId,
      'jouetId': jouetId,
      'nom': nom,
      'prixUnitaire': prixUnitaire,
      'quantite': quantite,
      'urlImage': urlImage,
    };
  }
}

class CartModel {
  final String utilisateurId;
  final List<CartItemModel> articles;

  CartModel({
    required this.utilisateurId,
    required this.articles,
  });

  double get totalGeneral =>
      articles.fold(0.0, (sum, item) => sum + item.totalArticle);

  int get nombreArticlesTotal =>
      articles.fold(0, (sum, item) => sum + item.quantite);
      factory CartModel.fromFirestore(
      String utilisateurId,
      List<Map<String, dynamic>> documents,
      List<String> ids) {
    final items = <CartItemModel>[];
    for (int i = 0; i < documents.length; i++) {
      items.add(CartItemModel.fromFirestore(documents[i], ids[i], ids));
    }
    return CartModel(utilisateurId: utilisateurId, articles: items);
  }
}