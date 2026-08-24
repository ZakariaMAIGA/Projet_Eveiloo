import 'package:cloud_firestore/cloud_firestore.dart';

/// Méthodes de paiement proposées sur l'écran "Paiement".
enum MethodePaiement {
  orangeMoney,
  moovMoney,
  carteBancaire,
  especes,
}

extension MethodePaiementX on MethodePaiement {
  /// Libellé affiché à l'écran.
  String get libelle {
    switch (this) {
      case MethodePaiement.orangeMoney:
        return 'Orange Money';
      case MethodePaiement.moovMoney:
        return 'Moov Money';
      case MethodePaiement.carteBancaire:
        return 'Carte bancaire';
      case MethodePaiement.especes:
        return 'Espèces à la livraison';
    }
  }

  /// Valeur stockée en base (Firestore).
  String get code {
    switch (this) {
      case MethodePaiement.orangeMoney:
        return 'orange_money';
      case MethodePaiement.moovMoney:
        return 'moov_money';
      case MethodePaiement.carteBancaire:
        return 'carte_bancaire';
      case MethodePaiement.especes:
        return 'especes';
    }
  }

  /// true si la méthode nécessite la saisie d'un code secret
  /// (mobile money). La carte et les espèces suivent un autre parcours.
  bool get necessiteCodeSecret =>
      this == MethodePaiement.orangeMoney || this == MethodePaiement.moovMoney;

  static MethodePaiement fromCode(String code) {
    return MethodePaiement.values.firstWhere(
      (m) => m.code == code,
      orElse: () => MethodePaiement.especes,
    );
  }
}

/// Statut d'un paiement.
enum StatutPaiement { enAttente, valide, echoue }

extension StatutPaiementX on StatutPaiement {
  String get valeur {
    switch (this) {
      case StatutPaiement.enAttente:
        return 'en_attente';
      case StatutPaiement.valide:
        return 'valide';
      case StatutPaiement.echoue:
        return 'echoue';
    }
  }

  static StatutPaiement fromValeur(String valeur) {
    switch (valeur) {
      case 'valide':
        return StatutPaiement.valide;
      case 'echoue':
        return StatutPaiement.echoue;
      default:
        return StatutPaiement.enAttente;
    }
  }
}

class PaiementModel {
  final String paiementId;
  final String commandeId;
  final String utilisateurId;
  final double montant;
  final MethodePaiement methode;
  final StatutPaiement statut;
  final DateTime dateCreation;

  PaiementModel({
    required this.paiementId,
    required this.commandeId,
    required this.utilisateurId,
    required this.montant,
    required this.methode,
    required this.statut,
    required this.dateCreation,
  });

  factory PaiementModel.fromFirestore(Map<String, dynamic> json, String id) {
    return PaiementModel(
      paiementId: id,
      commandeId: json['commandeId'] ?? '',
      utilisateurId: json['utilisateurId'] ?? '',
      montant: (json['montant'] as num?)?.toDouble() ?? 0.0,
      methode: MethodePaiementX.fromCode(json['methode'] ?? ''),
      statut: StatutPaiementX.fromValeur(json['statut'] ?? 'en_attente'),
      dateCreation: (json['dateCreation'] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'commandeId': commandeId,
      'utilisateurId': utilisateurId,
      'montant': montant,
      'methode': methode.code,
      'statut': statut.valeur,
      'dateCreation': Timestamp.fromDate(dateCreation),
    };
  }
}
