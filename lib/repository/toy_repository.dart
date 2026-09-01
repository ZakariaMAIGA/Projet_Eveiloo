import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eveiloo_enfant/models/CategorieJouetModel.dart';
import '../models/toy_model.dart';

class ToyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer la liste des catégories
  Stream<List<CategorieJouetModel>> getCategories() {
    return _firestore.collection('CATEGORIES').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CategorieJouetModel.fromMap(Map<String, dynamic>.from(data));
      }).toList();
    });
  }

  // Récupérer les jouets filtrés par genre et âge
  Stream<List<ToyModel>> getToysByGenreAndAge({
    required String genre,
    required String ageFilter,
  }) {
    Query<Map<String, dynamic>> query = _firestore
        .collection('JOUETS')
        .where('genre', isEqualTo: genre.toLowerCase());

    if (ageFilter != 'Tous') {
      query = query.where('ageRange', isEqualTo: ageFilter);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ToyModel.fromFirestore(Map<String, dynamic>.from(data), doc.id);
      }).toList();
    });
  }

  // Récupérer les jouets par catégorie (si besoin)
  Stream<List<ToyModel>> getToys({String? categorieId}) {
    Query<Map<String, dynamic>> query = _firestore.collection('JOUETS');

    if (categorieId != null && categorieId.isNotEmpty) {
      query = query.where('categorieId', isEqualTo: categorieId);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ToyModel.fromFirestore(Map<String, dynamic>.from(data), doc.id);
      }).toList();
    });
  }

  // Ajouter un nouveau jouet dans Firestore
  Future<void> addToy(ToyModel toy) async {
    await _firestore.collection('JOUETS').add(toy.toMap());
  }

  // Supprimer un jouet
  Future<void> deleteToy(String toyId) async {
    await _firestore.collection('JOUETS').doc(toyId).delete();
  }

  // Récupère la liste des objets ToyModel à partir d'une liste d'IDs
  Future<List<ToyModel>> getJouetsParIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    // Note: Firestore limite whereIn à 30 éléments par requête
    final snapshot = await FirebaseFirestore.instance
        .collection('JOUETS')
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return snapshot.docs
        .map((doc) => ToyModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}
