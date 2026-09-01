import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/commande.dart';

class CommandeRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Stream<List<Commande>> getCommandesUtilisateur(
    String utilisateurId,
  ) {
    return _firestore
        .collection('commandes')
        .where(
          'utilisateurId',
          isEqualTo: utilisateurId,
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Commande.fromJson(doc.data());
      }).toList();
    });
  }
}