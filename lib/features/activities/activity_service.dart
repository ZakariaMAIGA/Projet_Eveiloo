import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/activity_model.dart';
import '../../models/question_model.dart';

class ActivityService {
  ActivityService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  final String collection = "activities";

  CollectionReference<Map<String, dynamic>> _activeSessions(
    String activityId,
  ) => _firestore.collection(collection).doc(activityId).collection('activeSessions');

  Future<void> ensureActivityIsNotInUse(String activityId) async {
    final snapshot = await _activeSessions(activityId)
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      throw StateError(
        'Cette activité est actuellement utilisée par un enfant',
      );
    }
  }

  Future<String> startActivitySession(
    String activityId,
    int durationSeconds,
  ) async {
    final session = _activeSessions(activityId).doc();
    final expiresAt = DateTime.now().add(
      Duration(seconds: durationSeconds > 0 ? durationSeconds + 30 : 1800),
    );
    await session.set({
      'startedAt': Timestamp.now(),
      'expiresAt': Timestamp.fromDate(expiresAt),
    });
    return session.id;
  }

  /// Marque l'activité comme « En cours » côté enfant en écrivant [startedAt].
  ///
  /// Si l'activité est déjà terminée ([completedAt] renseigné), on ne fait
  /// rien : refaire l'activité 1000 fois ne doit jamais faire régresser son
  /// statut « Terminée » ni sa progression.
  Future<void> markActivityStarted(String activityId) async {
    final ref = _firestore.collection(collection).doc(activityId);
    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(ref);
      if (!doc.exists) return;

      final data = doc.data()!;
      final alreadyCompleted = data['completedAt'] != null &&
          data['completedAt'].toString().isNotEmpty;
      if (alreadyCompleted) return;

      transaction.update(ref, {
        'startedAt': DateTime.now().toIso8601String(),
      });
    });
  }

  /// Enregistre la progression d'une activité que l'enfant vient de terminer.
  ///
  /// - La progression = pourcentage du score de LA PREMIÈRE fois : si
  ///   [completedAt] est déjà renseigné, on ne modifie strictement rien,
  ///   même si l'enfant rejoue l'activité 1000 fois.
  /// - Sinon, on écrit [completedAt] (date de fin) et [progress] (score).
  Future<void> completeActivity(
    String activityId, {
    required int score,
    required int totalQuestions,
  }) async {
    final ref = _firestore.collection(collection).doc(activityId);
    final progress = totalQuestions == 0
        ? 100.0
        : ((score / totalQuestions) * 100).clamp(0.0, 100.0).toDouble();

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(ref);
      if (!doc.exists) return;

      final data = doc.data()!;
      final alreadyCompleted = data['completedAt'] != null &&
          data['completedAt'].toString().isNotEmpty;
      if (alreadyCompleted) return;

      transaction.update(ref, {
        'progress': progress,
        'completedAt': DateTime.now().toIso8601String(),
      });
    });
  }

  Future<void> endActivitySession(String activityId, String sessionId) {
    return _activeSessions(activityId).doc(sessionId).delete();
  }

  /// ===========================
  /// ACTIVITIES
  /// ===========================

  /// Ajouter une activité
  Future<void> addActivity(ActivityModel activity) async {
    final usersSnapshot = await _firestore
        .collection('utilisateurs')
        .where('role', isEqualTo: 'parent')
        .get();

    final batch = _firestore.batch();
    final activityRef = _firestore
        .collection(collection)
        .doc(activity.activityId);
    batch.set(activityRef, activity.toMap());

    for (final user in usersSnapshot.docs) {
      final notificationRef = _firestore.collection('notifications').doc();
      batch.set(notificationRef, {
        'idUtilisateur': user.id,
        'titre': 'Nouvelle activité disponible',
        'message': 'Découvre l’activité « ${activity.title} ».',
        'type': 'nouvelle_activite',
        'activityId': activity.activityId,
        'lu': false,
        'dateEnvoi': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  /// Modifier une activité
  Future<void> updateActivity(ActivityModel activity) async {
    await ensureActivityIsNotInUse(activity.activityId);
    await _firestore
        .collection(collection)
        .doc(activity.activityId)
        .update(activity.toMap());
  }

  /// Supprimer une activité
  Future<void> deleteActivity(String activityId) async {
    await ensureActivityIsNotInUse(activityId);
    await _firestore
        .collection(collection)
        .doc(activityId)
        .delete();
  }

  /// Récupérer une activité
  Future<ActivityModel?> getActivity(String activityId) async {
    final doc = await _firestore
        .collection(collection)
        .doc(activityId)
        .get();

    if (!doc.exists) return null;

    return ActivityModel.fromMap(doc.data()!);
  }

  /// Toutes les activités

  Stream<List<ActivityModel>> getActivities() {
    return _firestore
        .collection(collection)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => ActivityModel.fromMap(doc.data()),
          )
          .toList();
    });
  }

  /// ===========================
  /// QUESTIONS
  /// ===========================

  /// Ajouter une question

  Future<void> addQuestion(
      String activityId,
      QuestionModel question,
      ) async {
        await ensureActivityIsNotInUse(activityId);
    await _firestore
        .collection(collection)
        .doc(activityId)
        .collection("questions")
        .doc(question.questionId)
        .set(question.toMap());
  }

  /// Modifier une question

  Future<void> updateQuestion(
      String activityId,
      QuestionModel question,
      ) async {
        await ensureActivityIsNotInUse(activityId);
    await _firestore
        .collection(collection)
        .doc(activityId)
        .collection("questions")
        .doc(question.questionId)
        .update(question.toMap());
  }

  /// Supprimer une question

  Future<void> deleteQuestion(
      String activityId,
      String questionId,
      ) async {
        await ensureActivityIsNotInUse(activityId);
    await _firestore
        .collection(collection)
        .doc(activityId)
        .collection("questions")
        .doc(questionId)
        .delete();
  }

  /// Récupérer une question

  Future<QuestionModel?> getQuestion(
      String activityId,
      String questionId,
      ) async {
    final doc = await _firestore
        .collection(collection)
        .doc(activityId)
        .collection("questions")
        .doc(questionId)
        .get();

    if (!doc.exists) return null;

    return QuestionModel.fromMap(doc.data()!);
  }

  /// Toutes les questions d'une activité

  Stream<List<QuestionModel>> getQuestions(
      String activityId,
      ) {
    return _firestore
        .collection(collection)
        .doc(activityId)
        .collection("questions")
        .orderBy("createdAt")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => QuestionModel.fromMap(doc.data()),
          )
          .toList();
    });
  }
}