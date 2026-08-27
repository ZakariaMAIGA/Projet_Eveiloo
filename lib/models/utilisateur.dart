import 'package:cloud_firestore/cloud_firestore.dart';

/// Rôle de l'utilisateur dans l'application.
enum RoleUtilisateur {
  parent,
  admin;

  /// Conversion depuis la valeur stockée en base (String).
  static RoleUtilisateur fromString(String? value) {
    switch (value) {
      case 'admin':
        return RoleUtilisateur.admin;
      case 'parent':
      default:
        return RoleUtilisateur.parent;
    }
  }

  /// Conversion vers la valeur à stocker en base (String).
  String toValue() => name; // 'parent' ou 'admin'
}

class UtilisateurModel {
  final String utilisateurId;
  final String nom;
  final String prenom;
  final String courriel;
  final String telephone;
  final String urlAvatar;
  final RoleUtilisateur role; // 'parent' | 'admin'
  final DateTime dateCreation;
  final DateTime? derniereConnexion;

  UtilisateurModel({
    required this.utilisateurId,
    required this.nom,
    required this.prenom,
    required this.courriel,
    this.telephone = '',
    this.urlAvatar = '',
    this.role = RoleUtilisateur.parent,
    required this.dateCreation,
    this.derniereConnexion,
  });

  factory UtilisateurModel.fromMap(Map<String, dynamic> map, String id) {
    return UtilisateurModel(
      utilisateurId: id,
      nom: map['nom'] ?? '',
      prenom: map['prenom'] ?? '',
      courriel: map['courriel'] ?? '',
      telephone: map['telephone'] ?? '',
      urlAvatar: map['urlAvatar'] ?? '',
      role: RoleUtilisateur.fromString(map['role'] as String?),
      dateCreation: (map['dateCreation'] as Timestamp).toDate(),
      derniereConnexion: (map['derniereConnexion'] as Timestamp?) != null
          ? (map['derniereConnexion'] as Timestamp).toDate()
          : null,
    );
  }

  factory UtilisateurModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UtilisateurModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'courriel': courriel,
      'telephone': telephone,
      'urlAvatar': urlAvatar,
      'role': role.toValue(),
      'dateCreation': Timestamp.fromDate(dateCreation),
      'derniereConnexion': derniereConnexion != null
          ? Timestamp.fromDate(derniereConnexion!)
          : null,
    };
  }

  UtilisateurModel copyWith({
    String? nom,
    String? prenom,
    String? courriel,
    String? telephone,
    String? urlAvatar,
    RoleUtilisateur? role,
    DateTime? dateCreation,
    DateTime? derniereConnexion,
  }) {
    return UtilisateurModel(
      utilisateurId: utilisateurId,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      courriel: courriel ?? this.courriel,
      telephone: telephone ?? this.telephone,
      urlAvatar: urlAvatar ?? this.urlAvatar,
      role: role ?? this.role,
      dateCreation: dateCreation ?? this.dateCreation,
      derniereConnexion: derniereConnexion ?? this.derniereConnexion,
    );
  }
}
