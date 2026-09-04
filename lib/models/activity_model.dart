import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Convertit une valeur de date Firestore (Timestamp, DateTime ou chaîne
/// ISO 8601) en [DateTime], ou retourne null si vide/invalide.
DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

/// Catalogue pur : une activité n'a AUCUNE donnée d'exécution (pas de
/// progression, pas de statut). La progression est propre à chaque enfant
/// et vit dans `enfants/{enfantId}/activites_progress/{activityId}`
/// (voir ActiviteProgressModel) — jamais sur ce document partagé.
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
    this.imageUrl,
    this.objective,
    required this.createdAt,
  });

  /// Une activité est-elle adaptée à un enfant de cet âge ?
  bool estAdapteeA(int age) => age >= minAge && age <= maxAge;

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
      imageUrl: null,
      objective: null,
      createdAt: DateTime.now(),
    );
  }

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
      competenceCategory: competenceCategory ?? this.competenceCategory,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      successThreshold: successThreshold ?? this.successThreshold,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
      objective: objective ?? this.objective,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
      'imageUrl': imageUrl,
      'objective': objective,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      activityId: map['activityId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      minAge: map['minAge'] ?? 0,
      maxAge: map['maxAge'] ?? 0,
      activityType: map['activityType'] ?? '',
      competenceCategory: map['competenceCategory'] ?? '',
      rewardPoints: map['rewardPoints'] ?? 0,
      successThreshold: map['successThreshold'] ?? 0,
      duration: map['duration'] as int? ?? 0,
      imageUrl: map['imageUrl']?.toString(),
      objective: map['objective']?.toString(),
      createdAt: _parseDate(map['createdAt']) ?? DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());

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
    imageUrl,
    objective,
    createdAt,
  ];
}
