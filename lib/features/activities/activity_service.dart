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
  ) => _firestore
      .collection(collection)
      .doc(activityId)
      .collection('activeSessions');

  Future<void> ensureActivityIsNotInUse(String activityId) async {
    final snapshot = await _activeSessions(
      activityId,
    ).where('expiresAt', isGreaterThan: Timestamp.now()).limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      throw StateError(
        'Cette activité est actuellement utilisée par un enfant',
      );
    }
  }

  /// Verrou empêchant deux enfants de jouer la même activité en même temps
  /// sur un même appareil partagé. Sans lien avec la progression (qui vit
  /// désormais dans ActiviteProgressRepository, par enfant).
  Future<String> startActivitySession(
    String activityId,
    int durationSeconds,
  ) async {
    final session = _activeSessions(activityId).doc();
    final activity = _firestore.collection(collection).doc(activityId);
    final expiresAt = DateTime.now().add(
      Duration(seconds: durationSeconds > 0 ? durationSeconds + 30 : 1800),
    );
    await _firestore.runTransaction((transaction) async {
      final activitySnapshot = await transaction.get(activity);
      if (!activitySnapshot.exists) {
        throw StateError('Cette activité n\'existe plus.');
      }

      final data = activitySnapshot.data()!;
      final activeSessionId = data['activeSessionId']?.toString();
      final activeSessionExpiresAt = data['activeSessionExpiresAt'];
      final lockIsActive =
          activeSessionId != null &&
          activeSessionId.isNotEmpty &&
          activeSessionExpiresAt is Timestamp &&
          activeSessionExpiresAt.toDate().isAfter(DateTime.now());
      if (lockIsActive) {
        throw StateError('Cette activité est déjà utilisée par un enfant.');
      }

      transaction.set(session, {
        'startedAt': Timestamp.now(),
        'expiresAt': Timestamp.fromDate(expiresAt),
      });
      transaction.update(activity, {
        'activeSessionId': session.id,
        'activeSessionExpiresAt': Timestamp.fromDate(expiresAt),
      });
    });
    return session.id;
  }

  Future<void> endActivitySession(String activityId, String sessionId) async {
    final activity = _firestore.collection(collection).doc(activityId);
    final session = _activeSessions(activityId).doc(sessionId);
    await _firestore.runTransaction((transaction) async {
      final activitySnapshot = await transaction.get(activity);
      final sessionSnapshot = await transaction.get(session);
      if (!activitySnapshot.exists || !sessionSnapshot.exists) return;

      transaction.delete(session);
      if (activitySnapshot.data()?['activeSessionId'] == sessionId) {
        transaction.update(activity, {
          'activeSessionId': FieldValue.delete(),
          'activeSessionExpiresAt': FieldValue.delete(),
        });
      }
    });
  }

  /// ===========================
  /// ACTIVITIES (catalogue)
  /// ===========================

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
        'message': 'Découvre l\'activité « ${activity.title} ».',
        'type': 'nouvelle_activite',
        'activityId': activity.activityId,
        'lu': false,
        'dateEnvoi': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  Future<void> updateActivity(ActivityModel activity) async {
    final ref = _firestore.collection(collection).doc(activity.activityId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      if (!snapshot.exists) throw StateError('Cette activité n\'existe plus.');
      if (_hasActiveSession(snapshot.data()!)) {
        throw StateError(
          'Modification impossible : un enfant utilise cette activité.',
        );
      }
      transaction.update(ref, activity.toMap());
    });
  }

  Future<void> deleteActivity(String activityId) async {
    final ref = _firestore.collection(collection).doc(activityId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      if (!snapshot.exists) return;
      if (_hasActiveSession(snapshot.data()!)) {
        throw StateError(
          'Suppression impossible : un enfant utilise cette activité.',
        );
      }
      transaction.delete(ref);
    });
  }

  bool _hasActiveSession(Map<String, dynamic> data) {
    final expiresAt = data['activeSessionExpiresAt'];
    return data['activeSessionId'] != null &&
        data['activeSessionId'].toString().isNotEmpty &&
        expiresAt is Timestamp &&
        expiresAt.toDate().isAfter(DateTime.now());
  }

  Future<ActivityModel?> getActivity(String activityId) async {
    final doc = await _firestore.collection(collection).doc(activityId).get();
    if (!doc.exists) return null;
    return ActivityModel.fromMap(doc.data()!);
  }

  Stream<List<ActivityModel>> getActivities() {
    return _firestore
        .collection(collection)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ActivityModel.fromMap(doc.data()))
              .toList();
        });
  }

  /// ===========================
  /// QUESTIONS
  /// ===========================

  Future<void> addQuestion(String activityId, QuestionModel question) async {
    await ensureActivityIsNotInUse(activityId);
    await _firestore
        .collection(collection)
        .doc(activityId)
        .collection("questions")
        .doc(question.questionId)
        .set(question.toMap());
  }

  Future<void> updateQuestion(String activityId, QuestionModel question) async {
    await ensureActivityIsNotInUse(activityId);
    await _firestore
        .collection(collection)
        .doc(activityId)
        .collection("questions")
        .doc(question.questionId)
        .update(question.toMap());
  }

  Future<void> deleteQuestion(String activityId, String questionId) async {
    await ensureActivityIsNotInUse(activityId);
    await _firestore
        .collection(collection)
        .doc(activityId)
        .collection("questions")
        .doc(questionId)
        .delete();
  }

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

  Stream<List<QuestionModel>> getQuestions(String activityId) {
    return _firestore
        .collection(collection)
        .doc(activityId)
        .collection("questions")
        .orderBy("createdAt")
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => QuestionModel.fromMap(doc.data()))
              .toList();
        });
  }
}
