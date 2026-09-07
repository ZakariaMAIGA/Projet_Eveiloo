import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/utilisateur.dart';

class UtilisateurRepository {
  UtilisateurRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _utilisateurs =>
      _firestore.collection('utilisateurs');

  Future<void> creer(UtilisateurModel utilisateur) {
    return _utilisateurs
        .doc(utilisateur.utilisateurId)
        .set(utilisateur.toMap());
  }

  Future<UtilisateurModel?> obtenirParId(String utilisateurId) async {
    final document = await _utilisateurs.doc(utilisateurId).get();

    if (!document.exists) return null;

    return UtilisateurModel.fromFirestore(document);
  }

  Stream<UtilisateurModel?> observerParId(String utilisateurId) {
    return _utilisateurs.doc(utilisateurId).snapshots().map((document) {
      if (!document.exists) return null;

      return UtilisateurModel.fromFirestore(document);
    });
  }

  Future<void> mettreAJour(String utilisateurId, Map<String, dynamic> donnees) {
    return _utilisateurs.doc(utilisateurId).update(donnees);
  }

  Future<void> mettreAJourDerniereConnexion(String utilisateurId) {
    return _utilisateurs.doc(utilisateurId).update({
      'derniereConnexion': FieldValue.serverTimestamp(),
    });
  }

  // ===========================
  // ADMIN — dashboard
  // ===========================

  /// Nombre total d'utilisateurs (pour la carte statistique du dashboard).
  Future<int> compterUtilisateurs() async {
    final snapshot = await _utilisateurs.count().get();
    return snapshot.count ?? 0;
  }

  /// Flux de tous les utilisateurs, triés du plus récent au plus ancien.
  /// Utilisé pour la liste "Utilisateurs" côté admin.
  Stream<List<UtilisateurModel>> observerTousLesUtilisateurs() {
    return _utilisateurs
        .orderBy('dateCreation', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UtilisateurModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Les [limite] derniers utilisateurs créés, pour le bloc "Derniers
  /// utilisateurs" du dashboard admin.
  Stream<List<UtilisateurModel>> observerDerniersUtilisateurs({
    int limite = 3,
  }) {
    return _utilisateurs
        .orderBy('dateCreation', descending: true)
        .limit(limite)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UtilisateurModel.fromFirestore(doc))
              .toList(),
        );
  }
}
