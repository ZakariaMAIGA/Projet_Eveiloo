import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/favoris.dart';

class FavoriRepository {
  final FirebaseFirestore _firestore;

  /// Référence vers la sous-collection "favoris" d'un enfant, elle-même
  /// nichée sous son parent : utilisateurs/{parentId}/enfants/{enfantId}/favoris
  /// (même schéma que EnfantRepository).
  CollectionReference<Map<String, dynamic>> _favorisRef(
      String parentId,
      String enfantId,
      ) {
    return _firestore
        .collection('utilisateurs')
        .doc(parentId)
        .collection('enfants')
        .doc(enfantId)
        .collection('favoris');
  }

  /// Ajoute un favori dans la sous-collection de l'enfant
  Future<String> ajouter(
      String parentId,
      String enfantId,
      Favoris favori,
      ) async {
    final document = await _favorisRef(parentId, enfantId).add(favori.toJson());
    return document.id;
  }

  /// Supprime un favori d'un enfant
  Future<void> supprimer(String parentId, String enfantId, String favoriId) {
    return _favorisRef(parentId, enfantId).doc(favoriId).delete();
  }

  /// Obtenir un favori précis
  Future<Favoris?> obtenirParId(
      String parentId,
      String enfantId,
      String favoriId,
      ) async {
    final document = await _favorisRef(parentId, enfantId).doc(favoriId).get();

  Future<void> ajouter({
    required String enfantId,
    required String elementId,
    String type = 'jouet',
  }) async {
    final existant = await _ref
        .where('enfantId', isEqualTo: enfantId)
        .where('elementId', isEqualTo: elementId)
        .limit(1)
        .get();
    if (existant.docs.isNotEmpty) return; // déjà en favori

    await _ref.add({
      'enfantId': enfantId,
      'elementId': elementId,
      'type': type,
      'dateAjout': Timestamp.now(),
    });
  }

  /// Écoute en temps réel la sous-collection de l'enfant
  Stream<List<Favoris>> observerParEnfant(String parentId, String enfantId) {
    return _favorisRef(parentId, enfantId).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Favoris.fromFirestore(doc)).toList());
  }

  /// Vérifie si un élément est en favori
  Future<bool> estFavori(
      String parentId,
      String enfantId,
      String elementId,
      ) async {
    final snapshot = await _favorisRef(parentId, enfantId)
        .where('elementId', isEqualTo: elementId)
        .limit(1)
        .get();

    if (existant.docs.isNotEmpty) {
      for (final doc in existant.docs) {
        await doc.reference.delete();
      }
    } else {
      await _ref.add({
        'enfantId': enfantId,
        'elementId': elementId,
        'type': type,
        'dateAjout': Timestamp.now(),
      });
    }
  }
}
