import 'dart:convert';

import 'package:equatable/equatable.dart';

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
      createdAt: DateTime.parse(map['createdAt']),
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
      ];
}