import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../models/toy_model.dart';

class ToyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer la liste des catégories
  Stream<List<CategoryModel>> getCategories() {
    return _firestore.collection('CATEGORIES').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CategoryModel.fromFirestore(
          Map<String, dynamic>.from(data),
          doc.id,
        );
      }).toList();
    });
  }

  /// Récupère les jouets filtrés par genre, tranche d'âge (bucket exact,
  /// ex: "4-6 ans") et optionnellement par catégorie.
  Stream<List<ToyModel>> getToysByGenreAndAge({
    required String genre,
    required String ageFilter,
    String? categorieId,
  }) {
    Query<Map<String, dynamic>> query = _firestore
        .collection('JOUETS')
        .where('genre', isEqualTo: genre.toLowerCase());

    if (ageFilter != 'Tous') {
      query = query.where('ageRange', isEqualTo: ageFilter);
    }

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

  // Récupérer les jouets par catégorie (si besoin, sans filtre genre/âge)
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

  // Récupérer plusieurs jouets par leurs ids (utile pour les favoris).
  // Découpe automatiquement en lots de 10, limite Firestore pour `whereIn`
  // sur l'id du document.
  Future<List<ToyModel>> getJouetsParIds(List<String> toyIds) async {
    if (toyIds.isEmpty) return [];

    final resultats = <ToyModel>[];
    for (var i = 0; i < toyIds.length; i += 10) {
      final fin = (i + 10 > toyIds.length) ? toyIds.length : i + 10;
      final lot = toyIds.sublist(i, fin);

      final snapshot = await _firestore
          .collection('JOUETS')
          .where(FieldPath.documentId, whereIn: lot)
          .get();

      resultats.addAll(
        snapshot.docs.map(
              (doc) => ToyModel.fromFirestore(
            Map<String, dynamic>.from(doc.data()),
            doc.id,
          ),
        ),
      );
    }
    return resultats;
  /// Écoute en temps réel un jouet précis (page détail).
  Stream<ToyModel?> streamToy(String toyId) {
    return _firestore.collection('JOUETS').doc(toyId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return ToyModel.fromFirestore(doc.data()!, doc.id);
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

    final snapshot = await _firestore
        .collection('JOUETS')
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return snapshot.docs
        .map((doc) => ToyModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}
