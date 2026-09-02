import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/journal_progres_model.dart';

class JournalProgresRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collection = 'journal_progres';

  CollectionReference<Map<String, dynamic>> get _ref =>
      _firestore.collection(collection);

  /// Ajoute une entrée au journal de progrès (appelé quand l'enfant
  /// termine une activité ou un tutoriel).
  Future<void> ajouterEntree(JournalProgresModel entree) async {
    await _ref.doc().set(entree.toMap());
  }

  /// Flux des activités/tutoriels récents pour un ou plusieurs enfants.
  /// Utilisé pour la section "Activités Récentes" du dashboard enfant.
  Stream<List<JournalProgresModel>> observerActivitesRecentes(
    List<String> enfantIds, {
    int limite = 10,
  }) {
    if (enfantIds.isEmpty) return Stream.value([]);

    return _ref.where('enfantId', whereIn: enfantIds).snapshots().map((
      snapshot,
    ) {
      final entrees = snapshot.docs
          .map((doc) => JournalProgresModel.fromMap(doc.data(), doc.id))
          .toList();

      entrees.sort((a, b) {
        final dateA = a.dateRealisation ?? DateTime(0);
        final dateB = b.dateRealisation ?? DateTime(0);
        return dateB.compareTo(dateA);
      });

      return entrees.take(limite).toList();
    });
  }

  /// Toutes les entrées du journal pour un enfant précis (sans tri Firestore,
  /// pour éviter un index composite ; le tri/filtre se fait côté client).
  Stream<List<JournalProgresModel>> observerToutesActivites(String enfantId) {
    return _ref
        .where('enfantId', isEqualTo: enfantId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => JournalProgresModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
