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

  /// Les [limite] derniers jouets ajoutés, plus récent en premier.
  /// ⚠️ Un jouet créé avant l'ajout du champ `dateAjout` n'a pas ce champ
  /// en base : Firestore l'exclut de ce tri (comportement standard pour
  /// orderBy sur un champ absent). Pour qu'il apparaisse, ré-enregistre-le
  /// une fois (ex: petite modification + sauvegarde depuis l'admin).
  Stream<List<ToyModel>> observerDerniersJouets({int limite = 5}) {
    return _firestore
        .collection('JOUETS')
        .orderBy('dateAjout', descending: true)
        .limit(limite)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ToyModel.fromFirestore(
              Map<String, dynamic>.from(doc.data()),
              doc.id,
            );
          }).toList();
        });
  }

  /// Écoute en temps réel un jouet précis (page détail).
  Stream<ToyModel?> streamToy(String toyId) {
    return _firestore.collection('JOUETS').doc(toyId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return ToyModel.fromFirestore(doc.data()!, doc.id);
    });
  }

  // Ajouter un nouveau jouet dans Firestore
  Future<void> addToy(ToyModel toy) async {
    final donnees = toy.toMap();
    donnees['dateAjout'] = FieldValue.serverTimestamp();
    await _firestore.collection('JOUETS').add(donnees);
  }

  // Supprimer un jouet
  Future<void> deleteToy(String toyId) async {
    await _firestore.collection('JOUETS').doc(toyId).delete();
  }

  // Modifier un jouet existant
  Future<void> updateToy(String toyId, Map<String, dynamic> donnees) async {
    await _firestore.collection('JOUETS').doc(toyId).update(donnees);
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

  // ===========================
  // ADMIN — dashboard
  // ===========================

  /// Nombre total de jouets, pour la carte statistique du dashboard admin.
  Future<int> compterJouets() async {
    final snapshot = await _firestore.collection('JOUETS').count().get();
    return snapshot.count ?? 0;
  }
}
