import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/favori.dart';

class FavoriRepository {
  FavoriRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _favoris =>
      _firestore.collection('favoris');

  Future<String> ajouter(FavoriModel favori) async {
    final document = await _favoris.add(favori.toMap());
    return document.id;
  }

  Future<void> supprimer(String favoriId) {
    return _favoris.doc(favoriId).delete();
  }

  Future<FavoriModel?> obtenirParId(String favoriId) async {
    final document = await _favoris.doc(favoriId).get();

    if (!document.exists) return null;

    return FavoriModel.fromFirestore(document);
  }

  Stream<List<FavoriModel>> observerParEnfant(String enfantId) {
    return _favoris
        .where('enfantId', isEqualTo: enfantId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavoriModel.fromFirestore(doc))
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
