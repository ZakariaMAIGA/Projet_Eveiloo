import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'proposition.dart';

/// Types de questions disponibles
enum QuestionType {
  multipleChoice,
  numeric,
  text,
}

class QuestionModel extends Equatable {
  final String questionId;

  /// Référence de l'activité à laquelle appartient la question
  final String activityId;

  /// Type de question
  final QuestionType type;

  /// Intitulé de la question
  final String statement;

  /// Objectif de la question
  final String objective;

  /// Image optionnelle associée à la question
  final String? image;

  /// Propositions (uniquement pour les QCM)
  final List<Proposition> options;

  /// Bonne réponse du QCM
  final String correctAnswer;

  /// Bonne réponse numérique
  final double? correctNumericAnswer;

  /// Marge d'erreur autorisée pour les réponses numériques
  final double tolerance;

  /// Bonne réponse texte
  final String freeTextAnswer;

  /// Sensible à la casse (pour les réponses texte)
  final bool caseSensitive;

  /// Date de création
  final DateTime createdAt;

  const QuestionModel({
    required this.questionId,
    required this.activityId,
    required this.type,
    required this.statement,
    required this.objective,
    this.image,
    required this.options,
    required this.correctAnswer,
    this.correctNumericAnswer,
    required this.tolerance,
    required this.freeTextAnswer,
    required this.caseSensitive,
    required this.createdAt,
  });

  /// Objet vide
  factory QuestionModel.empty() {
    return QuestionModel(
      questionId: '',
      activityId: '',
      type: QuestionType.multipleChoice,
      statement: '',
      objective: '',
      image: null,
      options: const [],
      correctAnswer: '',
      correctNumericAnswer: null,
      tolerance: 0,
      freeTextAnswer: '',
      caseSensitive: false,
      createdAt: DateTime.now(),
    );
  }

  /// Copier l'objet en modifiant uniquement certains champs
  QuestionModel copyWith({
    String? questionId,
    String? activityId,
    QuestionType? type,
    String? statement,
    String? objective,
    String? image,
    List<Proposition>? options,
    String? correctAnswer,
    double? correctNumericAnswer,
    double? tolerance,
    String? freeTextAnswer,
    bool? caseSensitive,
    DateTime? createdAt,
  }) {
    return QuestionModel(
      questionId: questionId ?? this.questionId,
      activityId: activityId ?? this.activityId,
      type: type ?? this.type,
      statement: statement ?? this.statement,
      objective: objective ?? this.objective,
      image: image ?? this.image,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      correctNumericAnswer:
          correctNumericAnswer ?? this.correctNumericAnswer,
      tolerance: tolerance ?? this.tolerance,
      freeTextAnswer: freeTextAnswer ?? this.freeTextAnswer,
      caseSensitive: caseSensitive ?? this.caseSensitive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Objet -> Map
  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'activityId': activityId,
      'type': type.name,
      'statement': statement,
      'objective': objective,
      'image': image,
      'options': options.map((prop) => prop.toMap()).toList(),
      'correctAnswer': correctAnswer,
      'correctNumericAnswer': correctNumericAnswer,
      'tolerance': tolerance,
      'freeTextAnswer': freeTextAnswer,
      'caseSensitive': caseSensitive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Map -> Objet
  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      questionId: map['questionId'] ?? '',
      activityId: map['activityId'] ?? '',
      type: QuestionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => QuestionType.multipleChoice,
      ),
      statement: map['statement'] ?? '',
      objective: map['objective'] ?? '',
      image: map['image'] as String?,
      options: (map['options'] as List<dynamic>? ?? [])
          .map((item) {
            if (item is Map<String, dynamic>) {
              return Proposition.fromMap(item);
            }
            // Backward compatibility: if options are strings, convert them to Proposition
            return Proposition(
              id: item.toString(),
              texte: item.toString(),
            );
          })
          .toList(),
      correctAnswer: map['correctAnswer'] ?? '',
      correctNumericAnswer:
          (map['correctNumericAnswer'] as num?)?.toDouble(),
      tolerance: (map['tolerance'] as num?)?.toDouble() ?? 0,
      freeTextAnswer: map['freeTextAnswer'] ?? '',
      caseSensitive: map['caseSensitive'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Objet -> JSON
  String toJson() => jsonEncode(toMap());

  /// JSON -> Objet
  factory QuestionModel.fromJson(String source) =>
      QuestionModel.fromMap(
        jsonDecode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [
        questionId,
        activityId,
        type,
        statement,
        objective,
        image,
        options,
        correctAnswer,
        correctNumericAnswer,
        tolerance,
        freeTextAnswer,
        caseSensitive,
        createdAt,
      ];
}