import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/cart_model.dart'; // contient CartItemModel

class CartService {
  final FirebaseFirestore _firestore;

  CartService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _articlesRef(String utilisateurId) {
    return _firestore
        .collection('paniers')
        .doc(utilisateurId)
        .collection('articles');
  }

  /// Écoute en temps réel le panier de l'utilisateur.
  Stream<List<CartItemModel>> streamPanier(String utilisateurId) {
    return _articlesRef(utilisateurId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CartItemModel.fromFirestore(doc);
      }).toList();
    });
  }

  /// Récupère le panier une seule fois (sans écoute temps réel).
  Future<List<CartItemModel>> recupererPanier(String utilisateurId) async {
    final snapshot = await _articlesRef(utilisateurId).get();
    return snapshot.docs.map((doc) {
      return CartItemModel.fromFirestore(doc);
    }).toList();
  }

  /// Ajoute un jouet au panier, ou incrémente sa quantité s'il y est déjà.
  Future<void> ajouterArticle({
    required String utilisateurId,
    required CartItemModel article,
  }) async {
    final ref = _articlesRef(utilisateurId);
    final existant = await ref
        .where('jouetId', isEqualTo: article.jouetId)
        .limit(1)
        .get();

    if (existant.docs.isNotEmpty) {
      final doc = existant.docs.first;
      final quantiteActuelle = (doc.data()['quantite'] as num?)?.toInt() ?? 0;
      await doc.reference.update({
        'quantite': quantiteActuelle + article.quantite,
      });
    } else {
      await ref.add(article.toMap());
    }
  }

  /// Met à jour la quantité d'un article du panier.
  Future<void> modifierQuantite({
    required String utilisateurId,
    required String articlePanierId,
    required int nouvelleQuantite,
  }) async {
    if (nouvelleQuantite <= 0) {
      await supprimerArticle(
        utilisateurId: utilisateurId,
        articlePanierId: articlePanierId,
      );
      return;
    }
    await _articlesRef(
      utilisateurId,
    ).doc(articlePanierId).update({'quantite': nouvelleQuantite});
  }

  /// Supprime un article du panier.
  Future<void> supprimerArticle({
    required String utilisateurId,
    required String articlePanierId,
  }) async {
    await _articlesRef(utilisateurId).doc(articlePanierId).delete();
  }

  /// Vide complètement le panier (ex: après validation de la commande).
  Future<void> viderPanier(String utilisateurId) async {
    final snapshot = await _articlesRef(utilisateurId).get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
