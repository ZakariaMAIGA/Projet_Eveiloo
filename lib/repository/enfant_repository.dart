import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/enfant.dart';

class EnfantRepository {
  EnfantRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _enfants(String parentId) =>
      _firestore.collection('utilisateurs').doc(parentId).collection('enfants');

  Future<String> creer(String parentId, EnfantModel enfant) async {
    final document = await _enfants(parentId).add(enfant.toMap());
    return document.id;
  }

  Stream<List<EnfantModel>> observerEnfants(String parentId) {
    return _enfants(parentId).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => EnfantModel.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  Stream<EnfantModel?> observerEnfantParId(String parentId, String enfantId) {
    return _enfants(parentId).doc(enfantId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return EnfantModel.fromMap(doc.data()!, doc.id);
    });
  }

  Future<EnfantModel?> obtenirParId(String parentId, String enfantId) async {
    final document = await _enfants(parentId).doc(enfantId).get();

    if (!document.exists) return null;

    return EnfantModel.fromMap(document.data()!, document.id);
  }

  Future<void> mettreAJour(
    String parentId,
    String enfantId,
    Map<String, dynamic> donnees,
  ) {
    return _enfants(parentId).doc(enfantId).update(donnees);
  }

  Future<void> supprimer(String parentId, String enfantId) {
    return _enfants(parentId).doc(enfantId).delete();
  }
}
