import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/question_model.dart';

class QuestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String activitiesCollection = 'activities';
  static const String questionsCollection = 'questions';

  /// Ajouter une question
  Future<void> addQuestion(
    String activityId,
    QuestionModel question,
  ) async {
    await _firestore
        .collection(activitiesCollection)
        .doc(activityId)
        .collection(questionsCollection)
        .doc(question.questionId)
        .set(question.toMap());
  }

  /// Modifier une question
  Future<void> updateQuestion(
    String activityId,
    QuestionModel question,
  ) async {
    await _firestore
        .collection(activitiesCollection)
        .doc(activityId)
        .collection(questionsCollection)
        .doc(question.questionId)
        .update(question.toMap());
  }

  /// Supprimer une question
  Future<void> deleteQuestion(
    String activityId,
    String questionId,
  ) async {
    await _firestore
        .collection(activitiesCollection)
        .doc(activityId)
        .collection(questionsCollection)
        .doc(questionId)
        .delete();
  }

  /// Récupérer une question
  Future<QuestionModel?> getQuestion(
    String activityId,
    String questionId,
  ) async {
    final doc = await _firestore
        .collection(activitiesCollection)
        .doc(activityId)
        .collection(questionsCollection)
        .doc(questionId)
        .get();

    if (!doc.exists) return null;

    return QuestionModel.fromMap(doc.data()!);
  }

  /// Récupérer toutes les questions d'une activité
  Stream<List<QuestionModel>> getQuestions(String activityId) {
    return _firestore
        .collection(activitiesCollection)
        .doc(activityId)
        .collection(questionsCollection)
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => QuestionModel.fromMap(doc.data()))
            .toList());
  }

  /// Remplacer toutes les questions d'une activité
  Future<void> replaceQuestions(
    String activityId,
    List<QuestionModel> questions,
  ) async {
    final batch = _firestore.batch();

    final questionsRef = _firestore
        .collection(activitiesCollection)
        .doc(activityId)
        .collection(questionsCollection);

    // Supprimer les anciennes questions
    final oldQuestions = await questionsRef.get();

    for (final doc in oldQuestions.docs) {
      batch.delete(doc.reference);
    }

    // Ajouter les nouvelles questions
    for (final question in questions) {
      batch.set(
        questionsRef.doc(question.questionId),
        question.toMap(),
      );
    }

    await batch.commit();
  }
}