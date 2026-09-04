import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/activite_progress_model.dart';
import '../models/activity_model.dart';
import '../models/journal_progres_model.dart';
import 'enfant_repository.dart';
import 'journal_progres_repository.dart';

class ActiviteProgressRepository {
  ActiviteProgressRepository({
    FirebaseFirestore? firestore,
    JournalProgresRepository? journalRepository,
    EnfantRepository? enfantRepository,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _journalRepository = journalRepository ?? JournalProgresRepository(),
       _enfantRepository = enfantRepository ?? EnfantRepository();

  final FirebaseFirestore _firestore;
  final JournalProgresRepository _journalRepository;
  final EnfantRepository _enfantRepository;

  CollectionReference<Map<String, dynamic>> _progressionsRef(String enfantId) =>
      _firestore
          .collection('enfants')
          .doc(enfantId)
          .collection('activites_progress');

  /// Flux de toute la progression d'un enfant, indexée par activityId.
  /// Un enfant sans aucun document ⇒ map vide ⇒ 0% partout, naturellement.
  Stream<Map<String, ActiviteProgressModel>> observerProgressions(
    String enfantId,
  ) {
    return _progressionsRef(enfantId).snapshots().map((snapshot) {
      return {
        for (final doc in snapshot.docs)
          doc.id: ActiviteProgressModel.fromMap(doc.data(), doc.id),
      };
    });
  }

  /// Marque l'activité comme démarrée pour cet enfant (idempotent : ne
  /// touche pas si déjà démarrée ou terminée).
  Future<void> marquerDemarree({
    required String enfantId,
    required String activityId,
  }) async {
    final ref = _progressionsRef(enfantId).doc(activityId);
    final doc = await ref.get();
    if (doc.exists) return; // déjà démarrée et/ou terminée

    await ref.set({
      'startedAt': Timestamp.now(),
      'completedAt': null,
      'score': 0,
    });
  }

  /// Marque l'activité comme terminée pour cet enfant. Idempotent : si déjà
  /// terminée, ne réécrit rien et ne redonne pas les points une seconde fois
  /// (rejouer une activité 1000 fois ne doit rapporter les points qu'une
  /// fois).
  ///
  /// [parentId] est l'utilisateur propriétaire du journal de progrès.
  /// [score] est le pourcentage de réussite (0-100).
  /// [pointsGagnes] est le montant réellement à créditer (déjà calculé au
  /// prorata du score par l'appelant, ex: score/total * rewardPoints).
  /// [dureeSecondes] est optionnel, pour l'historique.
  Future<void> marquerTerminee({
    required String parentId,
    required String enfantId,
    required ActivityModel activite,
    required double score,
    required int pointsGagnes,
    int dureeSecondes = 0,
  }) async {
    final ref = _progressionsRef(enfantId).doc(activite.activityId);
    final doc = await ref.get();

    final dejaTerminee =
        doc.exists && (doc.data()?['completedAt'] as Timestamp?) != null;
    if (dejaTerminee) return;

    await ref.set({
      'startedAt': doc.data()?['startedAt'] ?? Timestamp.now(),
      'completedAt': Timestamp.now(),
      'score': score,
    });

    // Historique + points, une seule fois (cohérent avec le flux tutoriel).
    await _journalRepository.ajouterEntree(
      JournalProgresModel(
        journalId: '',
        utilisateurId: parentId,
        enfantId: enfantId,
        elementId: activite.activityId,
        typeElement: TypeElementProgres.activite,
        titre: activite.title,
        score: score,
        dureeSecondes: dureeSecondes,
        pointsGagnes: pointsGagnes,
        dateRealisation: DateTime.now(),
      ),
    );

    await _enfantRepository.incrementerProgres(
      parentId,
      enfantId,
      points: pointsGagnes,
    );
  }
}
