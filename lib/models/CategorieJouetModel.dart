import 'package:cloud_firestore/cloud_firestore.dart';

class CategorieJouetModel {
  final String categoryId;
  final String name;
  final String description;
  final DateTime createdAt;

  // Constructeur principal
  const CategorieJouetModel({
    required this.categoryId,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  // Constructeur nommé : Map -> objet
  factory CategorieJouetModel.fromMap(Map<String, dynamic> map) {
    return CategorieJouetModel(
      categoryId: map['categoryId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      createdAt: _parseDate(map['createdAt']),
    );
  }

  // JSON -> objet
  factory CategorieJouetModel.fromJson(Map<String, dynamic> json) {
    return CategorieJouetModel.fromMap(json);
  }

  // Objet -> Map
  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Objet -> JSON
  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Créer une nouvelle version de l'objet
  CategorieJouetModel copyWith({
    String? categoryId,
    String? name,
    String? description,
    DateTime? createdAt,
  }) {
    return CategorieJouetModel(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'CategorieJouetModel('
        'categoryId: $categoryId, '
        'name: $name, '
        'description: $description, '
        'createdAt: $createdAt'
        ')';
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }
}