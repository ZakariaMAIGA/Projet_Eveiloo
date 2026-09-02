import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/utilisateur.dart';

class UtilisateurRepository {

UtilisateurRepository({
    FirebaseFirestore? firestore,
  }) : _firestore =  firestore ?? FirebaseFirestore.instance;

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

  Future<void> mettreAJour(
    String utilisateurId,
    Map<String, dynamic> donnees,
  ) {
    return _utilisateurs.doc(utilisateurId).update(donnees);
  }

  Future<void> mettreAJourDerniereConnexion(String utilisateurId) {
    return _utilisateurs.doc(utilisateurId).update({
      'derniereConnexion': FieldValue.serverTimestamp(),
    });
  }




}