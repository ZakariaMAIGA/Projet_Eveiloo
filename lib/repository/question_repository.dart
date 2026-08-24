import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/question_model.dart';

class QuestionRepository {
  QuestionRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _questions(String activityId) =>
      _firestore
          .collection('activities')
          .doc(activityId)
          .collection('questions');

  Future<void> create(QuestionModel question) {
    return _questions(
      question.activityId,
    ).doc(question.questionId).set(question.toMap());
  }

  Future<QuestionModel?> getById(String activityId, String questionId) async {
    final document = await _questions(activityId).doc(questionId).get();
    if (!document.exists || document.data() == null) return null;

    return QuestionModel.fromMap({
      ...document.data()!,
      'questionId': document.data()!['questionId'] ?? document.id,
      'activityId': document.data()!['activityId'] ?? activityId,
    });
  }

  Stream<QuestionModel?> watchById(String activityId, String questionId) {
    return _questions(activityId).doc(questionId).snapshots().map((document) {
      if (!document.exists || document.data() == null) return null;

      return QuestionModel.fromMap({
        ...document.data()!,
        'questionId': document.data()!['questionId'] ?? document.id,
        'activityId': document.data()!['activityId'] ?? activityId,
      });
    });
  }

  Stream<List<QuestionModel>> watchForActivity(String activityId) {
    return _questions(activityId)
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (document) => QuestionModel.fromMap({
                  ...document.data(),
                  'questionId': document.data()['questionId'] ?? document.id,
                  'activityId': document.data()['activityId'] ?? activityId,
                }),
              )
              .toList(),
        );
  }

  Future<void> update(QuestionModel question) {
    return _questions(
      question.activityId,
    ).doc(question.questionId).update(question.toMap());
  }

  Future<void> delete(String activityId, String questionId) {
    return _questions(activityId).doc(questionId).delete();
  }
}
