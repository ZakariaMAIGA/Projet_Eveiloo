import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/avis.dart';

class AvisRepository {
  AvisRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _avis =>
      _firestore.collection('avis');

  Future<String> creer(AvisModel avis) async {
    final document = await _avis.add(avis.toMap());
    return document.id;
  }

  Future<void> supprimer(String avisId) {
    return _avis.doc(avisId).delete();
  }

  Future<AvisModel?> obtenirParId(String avisId) async {
    final document = await _avis.doc(avisId).get();

    if (!document.exists) return null;

    return AvisModel.fromFirestore(document);
  }

  Stream<List<AvisModel>> observerParJouet(String jouetId) {
    return _avis
        .where('jouetId', isEqualTo: jouetId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AvisModel.fromFirestore(doc)).toList());
  }

  Future<void> mettreAJour(String avisId, Map<String, dynamic> donnees) {
    return _avis.doc(avisId).update(donnees);
  }
}
