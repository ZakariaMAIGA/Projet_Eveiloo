
import 'package:cloud_firestore/cloud_firestore.dart';

class UtilisateurModel{
  final String utilisateurId;
  final String nom;
  final String prenom;
  final String courriel;
  final String telephone;
  final String urlAvatar;
  final String role; // 'parent' | 'admin'
  final DateTime dateCreation;
  final DateTime? derniereConnexion;

  UtilisateurModel({
    required this.utilisateurId,
    required this.nom,
    required this.prenom,
    required this.courriel,
     this.telephone = '',
     this.urlAvatar = '',
    required this.role,
    required this.dateCreation,
    this.derniereConnexion,
  });


factory UtilisateurModel.fromMap(Map<String, dynamic> map, String id) {
  return UtilisateurModel(
    utilisateurId: id,
    nom: map['nom'] ?? '',
    prenom: map['prenom'] ?? '',
    courriel: map['courriel']   ?? '',
    telephone: map['telephone']     ?? '',
    urlAvatar: map['urlAvatar'] ?? '',
    role: map['role'] ?? 'parent',
    dateCreation: (map['dateCreation'] as Timestamp ).toDate(),
    derniereConnexion: (map['derniereConnexion'] as Timestamp?) != null ? (map['derniereConnexion'] as Timestamp).toDate() : null,
  );
}


   factory UtilisateurModel.fromFirestore(DocumentSnapshot doc){
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
      'role': role,
      'dateCreation': Timestamp.fromDate(dateCreation),
      'derniereConnexion':
          derniereConnexion != null ? Timestamp.fromDate(derniereConnexion!) : null,
    };
  }

  UtilisateurModel copyWith({
    String? nom,
    String? prenom,
    String? courriel,
    String? telephone,
    String? urlAvatar,
    String? role,
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