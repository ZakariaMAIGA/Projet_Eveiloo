import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/journal_progres_model.dart';

class JournalProgresRepository {
  JournalProgresRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _journal =>
      _firestore.collection('journal_progres');

  /// Dernières entrées (activités/tutoriels) réalisées par un ensemble
  /// d'enfants. `whereIn` est limité à 30 ids par Firestore — largement
  /// suffisant pour une famille.
  ///
  /// NB : Firestore va demander de créer un index composite
  /// (enfantId + dateRealisation) la première fois que cette requête
  /// tourne en dev — le lien pour le créer apparaît dans la console/logs.
  Stream<List<JournalProgresModel>> observerActivitesRecentes(
    List<String> enfantIds, {
    int limite = 5,
  }) {
    if (enfantIds.isEmpty) return Stream.value(const []);

    return _journal
        .where('enfantId', whereIn: enfantIds)
        .orderBy('dateRealisation', descending: true)
        .limit(limite)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => JournalProgresModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
