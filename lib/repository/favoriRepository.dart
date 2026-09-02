import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favoris.dart';

class FavoriRepository {
  FavoriRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Référence vers la sous-collection "favoris" d'un enfant spécifique
  CollectionReference<Map<String, dynamic>> _favorisRef(String enfantId) {
    return _firestore
        .collection('enfants')
        .doc(enfantId)
        .collection('favoris');
  }

  /// Ajoute un favori dans la sous-collection de l'enfant
  Future<String> ajouter(String enfantId, Favoris favori) async {
    final document = await _favorisRef(enfantId).add(favori.toJson());
    return document.id;
  }

  /// Supprime un favori d'un enfant
  Future<void> supprimer(String enfantId, String favoriId) {
    return _favorisRef(enfantId).doc(favoriId).delete();
  }

  /// Obtenir un favori précis
  Future<Favoris?> obtenirParId(String enfantId, String favoriId) async {
    final document = await _favorisRef(enfantId).doc(favoriId).get();

    if (!document.exists) return null;

    return Favoris.fromFirestore(document);
  }

  /// Écoute en temps réel la sous-collection de l'enfant
  Stream<List<Favoris>> observerParEnfant(String enfantId) {
    return _favorisRef(enfantId).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Favoris.fromFirestore(doc)).toList());
  }

  /// Vérifie si un élément est en favori
  Future<bool> estFavori(String enfantId, String elementId) async {
    final snapshot = await _favorisRef(enfantId)
        .where('elementId', isEqualTo: elementId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}