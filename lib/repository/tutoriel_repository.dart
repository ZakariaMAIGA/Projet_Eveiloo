import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/TutorielModel.dart';

class TutorielRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collection = 'tutoriels';

  CollectionReference<Map<String, dynamic>> get _ref =>
      _firestore.collection(collection);

  Stream<List<TutorielModel>> observerTutoriels() {
    return _firestore
        .collection(collection)
        .orderBy('dateCreation', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TutorielModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<TutorielModel?> getTutoriel(String tutorielId) async {
    final doc = await _firestore.collection(collection).doc(tutorielId).get();
    if (!doc.exists) return null;
    return TutorielModel.fromFirestore(doc);
  }

  // ===========================
  // ADMIN — gestion des tutoriels
  // ===========================

  /// Crée un nouveau tutoriel et retourne son identifiant.
  Future<String> ajouter(TutorielModel tutoriel) async {
    final doc = await _ref.add(tutoriel.toMap());
    return doc.id;
  }

  Future<void> mettreAJour(String tutorielId, Map<String, dynamic> donnees) {
    return _ref.doc(tutorielId).update(donnees);
  }

  Future<void> supprimer(String tutorielId) {
    return _ref.doc(tutorielId).delete();
  }

  /// Nombre total de tutoriels, pour la carte statistique du dashboard admin.
  Future<int> compterTutoriels() async {
    final snapshot = await _ref.count().get();
    return snapshot.count ?? 0;
  }
}
