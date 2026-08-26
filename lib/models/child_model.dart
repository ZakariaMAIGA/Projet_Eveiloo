// import 'package:flutter/material.dart';

// class ChildModel {
//   final String id;
//   final String name;
//   final int age;
//   final int level;
//   final double progress; // valeur entre 0.0 et 1.0
//   final String avatarUrl;
//   final Color accentColor;

//   const ChildModel({
//     required this.id,
//     required this.name,
//     required this.age,
//     required this.level,
//     required this.progress,
//     required this.avatarUrl,
//     required this.accentColor,
//   });

//   factory ChildModel.fromMap(
//     Map<String, dynamic> map, {
//     required Color accentColor,
//   }) {
//     return ChildModel(
//       id: map['id'] ?? '',
//       name: map['name'] ?? '',
//       age: map['age'] ?? 0,
//       level: map['level'] ?? 1,
//       progress: (map['progress'] ?? 0).toDouble(),
//       avatarUrl: map['avatarUrl'] ?? '',
//       accentColor: accentColor,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'age': age,
//       'level': level,
//       'progress': progress,
//       'avatarUrl': avatarUrl,
//     };
//   }
// }



class ChildModel {
  final String id;
  final String name;
  final int age;
  final int level;
  final double progression;
  final String imageUrl;

  ChildModel({
    required this.id,
    required this.name,
    required this.age,
    required this.level,
    required this.progression,
    required this.imageUrl,
  });
}