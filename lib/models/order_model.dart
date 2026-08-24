import 'package:cloud_firestore/cloud_firestore.dart';

/// Statut d'une commande, tel qu'affiché sur l'écran "Mes Commandes".
enum StatutCommande { enCours, livree, annulee }

extension StatutCommandeX on StatutCommande {
  /// Valeur stockée en base (Firestore).
  String get valeur {
    switch (this) {
      case StatutCommande.enCours:
        return 'en_cours';
      case StatutCommande.livree:
        return 'livree';
      case StatutCommande.annulee:
        return 'annulee';
    }
  }

  /// Libellé affiché dans le badge de statut (maquette "Mes Commandes").
  String get libelle {
    switch (this) {
      case StatutCommande.enCours:
        return 'En cours';
      case StatutCommande.livree:
        return 'Livrée';
      case StatutCommande.annulee:
        return 'Annuler';
    }
  }

  static StatutCommande fromValeur(String valeur) {
    switch (valeur) {
      case 'livree':
        return StatutCommande.livree;
      case 'annulee':
        return StatutCommande.annulee;
      default:
        return StatutCommande.enCours;
    }
  }
}

class Commande {
  final String commandeId;

  /// Numéro séquentiel lisible affiché à l'écran (ex: "1234" pour "#1234").
  /// Généré côté service via un compteur Firestore.
  final int numero;
  final String utilisateurId;
  final String adresseLivraison;
  final double montantTotal;
  final StatutCommande statut;
  final String? methodePaiement;
  final DateTime dateCommande;

  Commande({
    required this.commandeId,
    required this.numero,
    required this.utilisateurId,
    required this.adresseLivraison,
    required this.montantTotal,
    required this.statut,
    this.methodePaiement,
    required this.dateCommande,
  });

  /// Texte affiché dans la liste, ex: "Commande #1234".
  String get numeroAffiche => '#$numero';

  factory Commande.fromJson(Map<String, dynamic> json) {
    return Commande(
      commandeId: json['commandeId'] ?? '',
      numero: (json['numero'] as num?)?.toInt() ?? 0,
      utilisateurId: json['utilisateurId'] ?? '',
      adresseLivraison: json['adresseLivraison'] ?? '',
      montantTotal: (json['montantTotal'] as num).toDouble(),
      statut: StatutCommandeX.fromValeur(json['statut'] ?? 'en_cours'),
      methodePaiement: json['methodePaiement'],
      dateCommande: DateTime.parse(json['dateCommande']),
    );
  }

  /// Construction à partir d'un document Firestore (commandeId = doc.id).
  factory Commande.fromFirestore(Map<String, dynamic> json, String id) {
    return Commande(
      commandeId: id,
      numero: (json['numero'] as num?)?.toInt() ?? 0,
      utilisateurId: json['utilisateurId'] ?? '',
      adresseLivraison: json['adresseLivraison'] ?? '',
      montantTotal: (json['montantTotal'] as num?)?.toDouble() ?? 0.0,
      statut: StatutCommandeX.fromValeur(json['statut'] ?? 'en_cours'),
      methodePaiement: json['methodePaiement'],
      dateCommande:
          (json['dateCommande'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandeId': commandeId,
      'numero': numero,
      'utilisateurId': utilisateurId,
      'adresseLivraison': adresseLivraison,
      'montantTotal': montantTotal,
      'statut': statut.valeur,
      'methodePaiement': methodePaiement,
      'dateCommande': dateCommande.toString(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'numero': numero,
      'utilisateurId': utilisateurId,
      'adresseLivraison': adresseLivraison,
      'montantTotal': montantTotal,
      'statut': statut.valeur,
      'methodePaiement': methodePaiement,
      'dateCommande': Timestamp.fromDate(dateCommande),
    };
  }

  Commande copyWith({
    String? commandeId,
    int? numero,
    String? utilisateurId,
    String? adresseLivraison,
    double? montantTotal,
    StatutCommande? statut,
    String? methodePaiement,
    DateTime? dateCommande,
  }) {
    return Commande(
      commandeId: commandeId ?? this.commandeId,
      numero: numero ?? this.numero,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      adresseLivraison: adresseLivraison ?? this.adresseLivraison,
      montantTotal: montantTotal ?? this.montantTotal,
      statut: statut ?? this.statut,
      methodePaiement: methodePaiement ?? this.methodePaiement,
      dateCommande: dateCommande ?? this.dateCommande,
    );
  }
}
