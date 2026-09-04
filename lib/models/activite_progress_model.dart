import 'package:cloud_firestore/cloud_firestore.dart';

/// Progression d'UN enfant sur UNE activité.
/// Stocké dans `enfants/{enfantId}/activites_progress/{activityId}`.
/// Un enfant qui n'a jamais touché à une activité n'a simplement aucun
/// document ici : sa progression est 0 par construction, pas par calcul.
class ActiviteProgressModel {
  final String activityId;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double score; // pourcentage 0-100, du premier essai terminé

  const ActiviteProgressModel({
    required this.activityId,
    this.startedAt,
    this.completedAt,
    this.score = 0,
  });

  bool get isStarted => startedAt != null;
  bool get isCompleted => completedAt != null;

  factory ActiviteProgressModel.fromMap(Map<String, dynamic> map, String id) {
    return ActiviteProgressModel(
      activityId: id,
      startedAt: (map['startedAt'] as Timestamp?)?.toDate(),
      completedAt: (map['completedAt'] as Timestamp?)?.toDate(),
      score: (map['score'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startedAt': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
      'score': score,
    };
  }
}
