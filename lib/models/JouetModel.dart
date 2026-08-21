import 'package:cloud_firestore/cloud_firestore.dart';

class JouetModel {
  final String toyId;
  final String name;
  final String categoryId;
  final int recommendedAge;
  final double price;
  final int stock;
  final String description;
  final List<String> images;
  final String videoUrl;
  final List<String> benefits;
  final double averageRating;
  final int reviewCount;
  final DateTime createdAt;

  const JouetModel({
    required this.toyId,
    required this.name,
    required this.categoryId,
    required this.recommendedAge,
    required this.price,
    required this.stock,
    required this.description,
    required this.images,
    required this.videoUrl,
    required this.benefits,
    required this.averageRating,
    required this.reviewCount,
    required this.createdAt,
  });

  factory JouetModel.fromMap(Map<String, dynamic> map) {
    return JouetModel(
      toyId: map['toyId'] ?? '',
      name: map['name'] ?? '',
      categoryId: map['categoryId'] ?? '',
      recommendedAge: map['recommendedAge'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      stock: map['stock'] ?? 0,
      description: map['description'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      videoUrl: map['videoUrl'] ?? '',
      benefits: List<String>.from(map['benefits'] ?? []),
      averageRating: (map['averageRating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      createdAt: _parseDate(map['createdAt']),
    );
  }

  factory JouetModel.fromJson(Map<String, dynamic> json) {
    return JouetModel.fromMap(json);
  }

  Map<String, dynamic> toMap() {
    return {
      'toyId': toyId,
      'name': name,
      'categoryId': categoryId,
      'recommendedAge': recommendedAge,
      'price': price,
      'stock': stock,
      'description': description,
      'images': images,
      'videoUrl': videoUrl,
      'benefits': benefits,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'toyId': toyId,
      'name': name,
      'categoryId': categoryId,
      'recommendedAge': recommendedAge,
      'price': price,
      'stock': stock,
      'description': description,
      'images': images,
      'videoUrl': videoUrl,
      'benefits': benefits,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  JouetModel copyWith({
    String? toyId,
    String? name,
    String? categoryId,
    int? recommendedAge,
    double? price,
    int? stock,
    String? description,
    List<String>? images,
    String? videoUrl,
    List<String>? benefits,
    double? averageRating,
    int? reviewCount,
    DateTime? createdAt,
  }) {
    return JouetModel(
      toyId: toyId ?? this.toyId,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      recommendedAge: recommendedAge ?? this.recommendedAge,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      images: images ?? this.images,
      videoUrl: videoUrl ?? this.videoUrl,
      benefits: benefits ?? this.benefits,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'JouetModel('
        'toyId: $toyId, '
        'name: $name, '
        'price: $price, '
        'stock: $stock, '
        'averageRating: $averageRating'
        ')';
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }
}