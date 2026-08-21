
import 'package:cloud_firestore/cloud_firestore.dart';

class EnfantModel {
final String enfantId;
  final String prenom;
  final int age;
  final String urlAvatar;
  final int niveauAtteint;
  final int pointsGagnes;
  final int activitesRealisees;

  EnfantModel({
    required this.enfantId,
    required this.prenom,
    required this.age,
    this.urlAvatar = '',
    this.niveauAtteint = 0,
    this.pointsGagnes = 0,
    this.activitesRealisees = 0,
  })
;
  factory EnfantModel.fromMap(Map<String, dynamic> map, String id){
    return EnfantModel(
      enfantId: id,
      prenom: map['prenom'] ?? '',
      age: map['age'] ?? 0,
      urlAvatar: map['urlAvatar'] ?? '',
      niveauAtteint: map['niveauAtteint'] ?? 0,
      pointsGagnes: map['pointsGagnes'] ?? 0,
      activitesRealisees: map['activitesRealisees'] ?? 0,
    );
  }

  factory EnfantModel.fromFirestore( DocumentSnapshot doc){
    final data = doc.data() as Map<String , dynamic>;
    return EnfantModel.fromMap(data, doc.id);
  }

   Map<String, dynamic> toMap() {
    return {
      'prenom': prenom,
      'age': age,
      'urlAvatar': urlAvatar,
      'niveauAtteint': niveauAtteint,
      'pointsGagnes': pointsGagnes,
      'activitesRealisees': activitesRealisees,
    };
  }

  EnfantModel copyWith({
    String? prenom,
    int? age,
    String? urlAvatar,
    int? niveauAtteint,
    int? pointsGagnes,
    int? activitesRealisees,
  }) {
    return EnfantModel(
      enfantId: enfantId,
      prenom: prenom ?? this.prenom,
      age: age ?? this.age,
      urlAvatar: urlAvatar ?? this.urlAvatar,
      niveauAtteint: niveauAtteint ?? this.niveauAtteint,
      pointsGagnes: pointsGagnes ?? this.pointsGagnes,
      activitesRealisees: activitesRealisees ?? this.activitesRealisees,
    );
  
  }
}