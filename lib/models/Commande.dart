import 'package:cloud_firestore/cloud_firestore.dart';

enum StatutCommande {
  enAttente,
  confirmee,
  expediee,
  livree,
  annulee;

  static StatutCommande fromString(String? value) {
    switch (value) {
      case 'confirmee':
        return StatutCommande.confirmee;
      case 'expediee':
        return StatutCommande.expediee;
      case 'livree':
        return StatutCommande.livree;
      case 'annulee':
        return StatutCommande.annulee;
      case 'enAttente':
      default:
        return StatutCommande.enAttente;
    }
  }

  String toValue() => name;
}

class Commande {
  final String commandeId;
  final String utilisateurId;
  final String adresseLivraison;
  final double montantTotal;
  final StatutCommande statut;
  final DateTime? dateCommande;

  Commande({
    required this.commandeId,
    required this.utilisateurId,
    required this.adresseLivraison,
    this.montantTotal = 0,
    this.statut = StatutCommande.enAttente,
    required this.dateCommande,
  });

  factory Commande.fromMap(Map<String, dynamic> map, String id) {
    return Commande(
      commandeId: id,
      utilisateurId: map['utilisateurId'] ?? '',
      adresseLivraison: map['adresseLivraison'] ?? '',
      montantTotal: (map['montantTotal'] ?? 0).toDouble(),
      statut: StatutCommande.fromString(map['statut'] as String?),
      dateCommande: (map['dateCommande'] as Timestamp?)?.toDate(),
    );
  }

  factory Commande.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Commande.fromMap(doc.data() ?? {}, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'utilisateurId': utilisateurId,
      'adresseLivraison': adresseLivraison,
      'montantTotal': montantTotal,
      'statut': statut.toValue(),
      'dateCommande': dateCommande != null
          ? Timestamp.fromDate(dateCommande!)
          : FieldValue.serverTimestamp(),
    };
  }

  Commande copyWith({
    String? commandeId,
    String? utilisateurId,
    String? adresseLivraison,
    double? montantTotal,
    StatutCommande? statut,
    DateTime? dateCommande,
  }) {
    return Commande(
      commandeId: commandeId ?? this.commandeId,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      adresseLivraison: adresseLivraison ?? this.adresseLivraison,
      montantTotal: montantTotal ?? this.montantTotal,
      statut: statut ?? this.statut,
      dateCommande: dateCommande ?? this.dateCommande,
    );
  }
}
