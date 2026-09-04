import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/favoris.dart';

class FavoriRepository {
  final FirebaseFirestore _firestore;

  FavoriRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _ref =>
      _firestore.collection('favoris');

  /// Tous les favoris d'un enfant (jouets, tutoriels...).
  Stream<List<Favoris>> observerParEnfant(String enfantId) {
    return _ref
        .where('enfantId', isEqualTo: enfantId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Favoris.fromFirestore(doc)).toList(),
        );
  }

  /// Est-ce que cet élément est déjà en favori pour cet enfant ?
  Stream<bool> estFavori({
    required String enfantId,
    required String elementId,
  }) {
    return _ref
        .where('enfantId', isEqualTo: enfantId)
        .where('elementId', isEqualTo: elementId)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

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

  /// Supprime le favori (signature conservée pour favoris.dart :
  /// supprimer(enfantId, elementId)).
  Future<void> supprimer(String enfantId, String elementId) async {
    final docs = await _ref
        .where('enfantId', isEqualTo: enfantId)
        .where('elementId', isEqualTo: elementId)
        .get();
    for (final doc in docs.docs) {
      await doc.reference.delete();
    }
  }

  /// Bascule l'état favori (ajoute si absent, retire si présent).
  Future<void> basculerFavori({
    required String enfantId,
    required String elementId,
    String type = 'jouet',
  }) async {
    final existant = await _ref
        .where('enfantId', isEqualTo: enfantId)
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
