class Question {
  final String questionId;
  final String activiteId;
  final String type;
  final String enonce;
  final List<dynamic> propositions;
  final String? bonneReponseId;
  final double? bonneReponseNumerique;
  final double? tolerance;
  final String? bonneReponseTexte;
  final bool sensibleCasse;

  const Question({
    required this.questionId,
    required this.activiteId,
    required this.type,
    required this.enonce,
    this.propositions = const [],
    this.bonneReponseId,
    this.bonneReponseNumerique,
    this.tolerance,
    this.bonneReponseTexte,
    this.sensibleCasse = false,
  });

  /// Crée une [Question] à partir d'une Map (ex: document Firestore).
  ///
  /// [id] permet de fournir l'id du document Firestore (doc.id) si le champ
  /// `questionId` n'est pas stocké explicitement dans le document.
  factory Question.fromMap(Map<String, dynamic> map, {String? id}) {
    return Question(
      questionId: (id ?? map['questionId'] ?? '') as String,
      activiteId: (map['activiteId'] ?? '') as String,
      type: (map['type'] ?? '') as String,
      enonce: (map['enonce'] ?? '') as String,
      propositions: (map['propositions'] as List<dynamic>?) ?? const [],
      bonneReponseId: map['bonneReponseId'] as String?,
      bonneReponseNumerique: (map['bonneReponseNumerique'] as num?)
          ?.toDouble(),
      tolerance: (map['tolerance'] as num?)?.toDouble(),
      bonneReponseTexte: map['bonneReponseTexte'] as String?,
      sensibleCasse: (map['sensibleCasse'] as bool?) ?? false,
    );
  }

  /// Convertit la [Question] en Map (pour Firestore ou tout autre backend JSON).
  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'activiteId': activiteId,
      'type': type,
      'enonce': enonce,
      'propositions': propositions,
      'bonneReponseId': bonneReponseId,
      'bonneReponseNumerique': bonneReponseNumerique,
      'tolerance': tolerance,
      'bonneReponseTexte': bonneReponseTexte,
      'sensibleCasse': sensibleCasse,
    };
  }

  /// Retourne une copie de la question avec certains champs modifiés.
  Question copyWith({
    String? questionId,
    String? activiteId,
    String? type,
    String? enonce,
    List<dynamic>? propositions,
    String? bonneReponseId,
    double? bonneReponseNumerique,
    double? tolerance,
    String? bonneReponseTexte,
    bool? sensibleCasse,
  }) {
    return Question(
      questionId: questionId ?? this.questionId,
      activiteId: activiteId ?? this.activiteId,
      type: type ?? this.type,
      enonce: enonce ?? this.enonce,
      propositions: propositions ?? this.propositions,
      bonneReponseId: bonneReponseId ?? this.bonneReponseId,
      bonneReponseNumerique:
          bonneReponseNumerique ?? this.bonneReponseNumerique,
      tolerance: tolerance ?? this.tolerance,
      bonneReponseTexte: bonneReponseTexte ?? this.bonneReponseTexte,
      sensibleCasse: sensibleCasse ?? this.sensibleCasse,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Question &&
        other.questionId == questionId &&
        other.activiteId == activiteId &&
        other.type == type &&
        other.enonce == enonce &&
        _listEquals(other.propositions, propositions) &&
        other.bonneReponseId == bonneReponseId &&
        other.bonneReponseNumerique == bonneReponseNumerique &&
        other.tolerance == tolerance &&
        other.bonneReponseTexte == bonneReponseTexte &&
        other.sensibleCasse == sensibleCasse;
  }

  @override
  int get hashCode => Object.hash(
        questionId,
        activiteId,
        type,
        enonce,
        Object.hashAll(propositions),
        bonneReponseId,
        bonneReponseNumerique,
        tolerance,
        bonneReponseTexte,
        sensibleCasse,
      );

  @override
  String toString() {
    return 'Question(questionId: $questionId, activiteId: $activiteId, '
        'type: $type, enonce: $enonce, propositions: $propositions, '
        'bonneReponseId: $bonneReponseId, '
        'bonneReponseNumerique: $bonneReponseNumerique, '
        'tolerance: $tolerance, bonneReponseTexte: $bonneReponseTexte, '
        'sensibleCasse: $sensibleCasse)';
  }
}

/// Compare deux listes élément par élément (utilisé par `operator ==`).
bool _listEquals(List<dynamic> a, List<dynamic> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
