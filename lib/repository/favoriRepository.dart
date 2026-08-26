import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/favoris.dart';

class FavoriRepository {
  FavoriRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _favoris =>
      _firestore.collection('favoris');

  Future<String> ajouter(Favoris favori) async {
    final document = await _favoris.add(favori.toJson());
    return document.id;
  }

  Future<void> supprimer(String favoriId) {
    return _favoris.doc(favoriId).delete();
  }

  Future<Favoris?> obtenirParId(String favoriId) async {
    final document = await _favoris.doc(favoriId).get();

    if (!document.exists) return null;

    return Favoris.fromFirestore(document);
  }

  Stream<List<Favoris>> observerParEnfant(String enfantId) {
    return _favoris
        .where('enfantId', isEqualTo: enfantId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Favoris.fromFirestore(doc))
            .toList());
  }

  Future<bool> estFavori(String enfantId, String elementId) async {
    final snapshot = await _favoris
        .where('enfantId', isEqualTo: enfantId)
        .where('elementId', isEqualTo: elementId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
