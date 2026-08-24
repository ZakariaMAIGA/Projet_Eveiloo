class ProgressionModel {
  final String progressionId;
  final String childId;
  final String activityId;
  final double currentProgress;
  final int questionsAnswered;
  final int correctAnswers;
  final DateTime startedAt;
  final DateTime? completedAt;

  const ProgressionModel({
    required this.progressionId,
    required this.childId,
    required this.activityId,
    required this.currentProgress,
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.startedAt,
    this.completedAt,
  });

  /// Objet vide
  factory ProgressionModel.empty() {
    return ProgressionModel(
      progressionId: '',
      childId: '',
      activityId: '',
      currentProgress: 0.0,
      questionsAnswered: 0,
      correctAnswers: 0,
      startedAt: DateTime.now(),
      completedAt: null,
    );
  }

  /// Créer une [ProgressionModel] à partir d'une Map (ex: document Firestore).
  factory ProgressionModel.fromMap(Map<String, dynamic> map) {
    return ProgressionModel(
      progressionId: map['progressionId'] ?? '',
      childId: map['childId'] ?? '',
      activityId: map['activityId'] ?? '',
      currentProgress: (map['currentProgress'] as num?)?.toDouble() ?? 0.0,
      questionsAnswered: map['questionsAnswered'] as int? ?? 0,
      correctAnswers: map['correctAnswers'] as int? ?? 0,
      startedAt: map['startedAt'] != null
          ? DateTime.parse(map['startedAt'].toString())
          : DateTime.now(),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'].toString())
          : null,
    );
  }

  /// Convertir la [ProgressionModel] en Map (pour Firestore ou tout autre backend JSON).
  Map<String, dynamic> toMap() {
    return {
      'progressionId': progressionId,
      'childId': childId,
      'activityId': activityId,
      'currentProgress': currentProgress,
      'questionsAnswered': questionsAnswered,
      'correctAnswers': correctAnswers,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  /// Retourner une copie de la progression avec certains champs modifiés.
  ProgressionModel copyWith({
    String? progressionId,
    String? childId,
    String? activityId,
    double? currentProgress,
    int? questionsAnswered,
    int? correctAnswers,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return ProgressionModel(
      progressionId: progressionId ?? this.progressionId,
      childId: childId ?? this.childId,
      activityId: activityId ?? this.activityId,
      currentProgress: currentProgress ?? this.currentProgress,
      questionsAnswered: questionsAnswered ?? this.questionsAnswered,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProgressionModel &&
        other.progressionId == progressionId &&
        other.childId == childId &&
        other.activityId == activityId &&
        other.currentProgress == currentProgress &&
        other.questionsAnswered == questionsAnswered &&
        other.correctAnswers == correctAnswers &&
        other.startedAt == startedAt &&
        other.completedAt == completedAt;
  }

  @override
  int get hashCode =>
      progressionId.hashCode ^
      childId.hashCode ^
      activityId.hashCode ^
      currentProgress.hashCode ^
      questionsAnswered.hashCode ^
      correctAnswers.hashCode ^
      startedAt.hashCode ^
      completedAt.hashCode;

  @override
  String toString() =>
      'ProgressionModel(progressionId: $progressionId, childId: $childId, activityId: $activityId, currentProgress: $currentProgress, questionsAnswered: $questionsAnswered, correctAnswers: $correctAnswers, startedAt: $startedAt, completedAt: $completedAt)';
}
