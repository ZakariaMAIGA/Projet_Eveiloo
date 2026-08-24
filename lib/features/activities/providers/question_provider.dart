import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/question_model.dart';
import '../question_service.dart';

/// Service

final questionServiceProvider =
    Provider<QuestionService>((ref) {
  return QuestionService();
});

/// Questions d'une activité

final questionsProvider =
    StreamProvider.family<List<QuestionModel>, String>(
        (ref, activityId) {
  return ref
      .read(questionServiceProvider)
      .getQuestions(activityId);
});

/// Une seule question

final questionProvider = FutureProvider.family<
    QuestionModel?,
    ({String activityId, String questionId})>((ref, params) {
  return ref
      .read(questionServiceProvider)
      .getQuestion(
        params.activityId,
        params.questionId,
      );
});