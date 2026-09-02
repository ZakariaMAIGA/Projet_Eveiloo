import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Commande.dart';
import '../models/commande_article_model.dart';
import '../models/cart_model.dart';

class CommandeRepository {
  final FirebaseFirestore _firestore;

  CommandeRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _commandesRef =>
      _firestore.collection('commandes');

  CollectionReference<Map<String, dynamic>> _articlesRef(String commandeId) =>
      _commandesRef.doc(commandeId).collection('articles');

  /// Crée une commande à partir des articles du panier, puis vide le panier.
  Future<String> creerCommande({
    required String utilisateurId,
    required String adresseLivraison,
    required List<CartItemModel> articlesPanier,
  }) async {
    final montantTotal = articlesPanier.fold<double>(
      0,
      (sum, item) => sum + item.sousTotal,
    );

    final commandeRef = _commandesRef.doc();

    final batch = _firestore.batch();

    batch.set(commandeRef, {
      'utilisateurId': utilisateurId,
      'adresseLivraison': adresseLivraison,
      'montantTotal': montantTotal,
      'statut': StatutCommande.enAttente.toValue(),
      'dateCommande':
          Timestamp.now(), // ✅ valeur immédiatement disponible, pas de null transitoire
    });

    for (final item in articlesPanier) {
      final articleRef = _articlesRef(commandeRef.id).doc();
      batch.set(articleRef, {
        'jouetId': item.jouetId,
        'nom': item.nom,
        'prixUnitaire': item.prixUnitaire,
        'quantite': item.quantite,
        'urlImage': item.urlImage,
      });
    }

    // Vide le panier de l'utilisateur dans le même batch
    final panierSnapshot = await _firestore
        .collection('paniers')
        .doc(utilisateurId)
        .collection('articles')
        .get();
    for (final doc in panierSnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
    return commandeRef.id;
  }

  /// Liste des commandes d'un utilisateur, plus récentes en premier.
  Stream<List<Commande>> streamCommandes(String utilisateurId) {
    return _commandesRef
        .where('utilisateurId', isEqualTo: utilisateurId)
        .snapshots()
        .map((snapshot) {
          final commandes = snapshot.docs
              .map((doc) => Commande.fromFirestore(doc))
              .toList();
          commandes.sort((a, b) {
            if (a.dateCommande == null) return 1;
            if (b.dateCommande == null) return -1;
            return b.dateCommande!.compareTo(a.dateCommande!);
          });
          return commandes;
        });
  }

  /// Détail d'une commande.
  Future<Commande?> obtenirCommande(String commandeId) async {
    final doc = await _commandesRef.doc(commandeId).get();
    if (!doc.exists) return null;
    return Commande.fromFirestore(doc);
  }

  /// Articles d'une commande donnée.
  Stream<List<CommandeArticleModel>> streamArticlesCommande(String commandeId) {
    return _articlesRef(commandeId).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => CommandeArticleModel.fromFirestore(doc))
          .toList(),
    );
  }
}
