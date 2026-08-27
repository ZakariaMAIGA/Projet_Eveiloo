import 'dart:convert';

import 'package:equatable/equatable.dart';

/// Statut possible d'une activité vue par l'enfant :
/// - [statusAFaire] : jamais sélectionnée
/// - [statusEnCours] : sélectionnée mais pas encore terminée
/// - [statusTerminee] : jouée jusqu'au bout
enum ActivityStatus { aFaire, enCours, terminee }

extension ActivityStatusX on ActivityStatus {
  String get label {
    switch (this) {
      case ActivityStatus.aFaire:
        return 'À faire';
      case ActivityStatus.enCours:
        return 'En cours';
      case ActivityStatus.terminee:
        return 'Terminée';
    }
  }
}

class ActivityModel extends Equatable {
  final String activityId;
  final String title;
  final String description;
  final int minAge;
  final int maxAge;
  final String activityType;
  final String competenceCategory;
  final int rewardPoints;
  final int successThreshold;
  final int duration;
  final double progress;
  final String? imageUrl;
  final String? objective;
  final DateTime createdAt;

  /// Date à laquelle l'enfant a sélectionné/démarré l'activité (null = jamais).
  final DateTime? startedAt;

  /// Date à laquelle l'enfant a terminé l'activité (null = pas encore).
  final DateTime? completedAt;

  /// L'activité a-t-elle déjà été démarrée ?
  bool get isStarted => startedAt != null || completedAt != null;

  /// L'activité est-elle terminée ?
  bool get isCompleted => completedAt != null;

  /// Statut courant de l'activité pour l'enfant.
  ActivityStatus get status {
    if (completedAt != null) return ActivityStatus.terminee;
    if (isStarted) return ActivityStatus.enCours;
    return ActivityStatus.aFaire;
  }

  const ActivityModel({
    required this.activityId,
    required this.title,
    required this.description,
    required this.minAge,
    required this.maxAge,
    required this.activityType,
    required this.competenceCategory,
    required this.rewardPoints,
    required this.successThreshold,
    required this.duration,
    required this.progress,
    this.imageUrl,
    this.objective,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
  });

  /// Objet vide
  factory ActivityModel.empty() {
    return ActivityModel(
      activityId: '',
      title: '',
      description: '',
      minAge: 0,
      maxAge: 0,
      activityType: '',
      competenceCategory: '',
      rewardPoints: 0,
      successThreshold: 0,
      duration: 0,
      progress: 0.0,
      imageUrl: null,
      objective: null,
      createdAt: DateTime.now(),
    );
  }

  /// Copier l'objet en modifiant uniquement certains champs
  ActivityModel copyWith({
    String? activityId,
    String? title,
    String? description,
    int? minAge,
    int? maxAge,
    String? activityType,
    String? competenceCategory,
    int? rewardPoints,
    int? successThreshold,
    int? duration,
    double? progress,
    String? imageUrl,
    String? objective,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return ActivityModel(
      activityId: activityId ?? this.activityId,
      title: title ?? this.title,
      description: description ?? this.description,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      activityType: activityType ?? this.activityType,
      competenceCategory:
          competenceCategory ?? this.competenceCategory,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      successThreshold:
          successThreshold ?? this.successThreshold,
      duration: duration ?? this.duration,
      progress: progress ?? this.progress,
      imageUrl: imageUrl ?? this.imageUrl,
      objective: objective ?? this.objective,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      // completedAt est volontairement figé : on ne peut pas "dé-terminer"
      // une activité. Utiliser l'assignation directe si besoin de réinitialiser.
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Objet -> Map
  Map<String, dynamic> toMap() {
    return {
      'activityId': activityId,
      'title': title,
      'description': description,
      'minAge': minAge,
      'maxAge': maxAge,
      'activityType': activityType,
      'competenceCategory': competenceCategory,
      'rewardPoints': rewardPoints,
      'successThreshold': successThreshold,
      'duration': duration,
      'progress': progress,
      'imageUrl': imageUrl,
      'objective': objective,
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  /// Map -> Objet
  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      activityId: map['activityId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      minAge: map['minAge'] ?? 0,
      maxAge: map['maxAge'] ?? 0,
      activityType: map['activityType'] ?? '',
      competenceCategory:
          map['competenceCategory'] ?? '',
      rewardPoints: map['rewardPoints'] ?? 0,
      successThreshold:
          map['successThreshold'] ?? 0,
      duration: map['duration'] as int? ?? 0,
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl']?.toString(),
      objective: map['objective']?.toString(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'].toString())
          : DateTime.now(),
      startedAt: map['startedAt'] != null
          ? DateTime.tryParse(map['startedAt'].toString())
          : null,
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'].toString())
          : null,
    );
  }

  /// Objet -> JSON
  String toJson() => jsonEncode(toMap());

  /// JSON -> Objet
  factory ActivityModel.fromJson(String source) =>
      ActivityModel.fromMap(jsonDecode(source));

  @override
  List<Object?> get props => [
        activityId,
        title,
        description,
        minAge,
        maxAge,
        activityType,
        competenceCategory,
        rewardPoints,
        successThreshold,
        duration,
        progress,
        imageUrl,
        objective,
        createdAt,
        startedAt,
        completedAt,
      ];
}