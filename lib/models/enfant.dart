import 'package:cloud_firestore/cloud_firestore.dart';

class EnfantModel {
  final String enfantId;
  final String prenom;
  final String nom;
  final String dateNaissance;
  final String genre;
  final String niveauScolaire;
  final String centresInteret;
  final String urlAvatar;
  final int niveauAtteint;
  final int pointsGagnes;
  final int activitesRealisees;

  EnfantModel({
    required this.enfantId,
    required this.prenom,
    this.nom = '',
    required this.dateNaissance,
    required this.genre,
    this.niveauScolaire = '',
    this.centresInteret = '',
    this.urlAvatar = '',
    this.niveauAtteint = 0,
    this.pointsGagnes = 0,
    this.activitesRealisees = 0,
  });

  factory EnfantModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return EnfantModel(
      enfantId: id,
      prenom: map['prenom'] ?? '',
      nom: map['nom'] ?? '',
      dateNaissance: map['dateNaissance'] ?? '',
      genre: map['genre'] ?? '',
      niveauScolaire: map['niveauScolaire'] ?? '',
      centresInteret: map['centresInteret'] ?? '',
      urlAvatar: map['urlAvatar'] ?? '',
      niveauAtteint: map['niveauAtteint'] ?? 0,
      pointsGagnes: map['pointsGagnes'] ?? 0,
      activitesRealisees:
          map['activitesRealisees'] ?? 0,
    );
  }

  factory EnfantModel.fromFirestore(
    DocumentSnapshot doc,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    return EnfantModel.fromMap(
      data,
      doc.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prenom': prenom,
      'nom': nom,
      'dateNaissance': dateNaissance,
      'genre': genre,
      'niveauScolaire': niveauScolaire,
      'centresInteret': centresInteret,
      'urlAvatar': urlAvatar,
      'niveauAtteint': niveauAtteint,
      'pointsGagnes': pointsGagnes,
      'activitesRealisees': activitesRealisees,
    };
  }

  EnfantModel copyWith({
    String? prenom,
    String? nom,
    String? dateNaissance,
    String? genre,
    String? niveauScolaire,
    String? centresInteret,
    String? urlAvatar,
    int? niveauAtteint,
    int? pointsGagnes,
    int? activitesRealisees,
  }) {
    return EnfantModel(
      enfantId: enfantId,
      prenom: prenom ?? this.prenom,
      nom: nom ?? this.nom,
      dateNaissance:
          dateNaissance ?? this.dateNaissance,
      genre: genre ?? this.genre,
      niveauScolaire:
          niveauScolaire ?? this.niveauScolaire,
      centresInteret:
          centresInteret ?? this.centresInteret,
      urlAvatar: urlAvatar ?? this.urlAvatar,
      niveauAtteint:
          niveauAtteint ?? this.niveauAtteint,
      pointsGagnes:
          pointsGagnes ?? this.pointsGagnes,
      activitesRealisees:
          activitesRealisees ?? this.activitesRealisees,
    );
  }
}