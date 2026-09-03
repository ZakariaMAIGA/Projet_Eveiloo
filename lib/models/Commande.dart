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
  final String numeroCommande;
  final String utilisateurId;
  final String adresseLivraison;
  final double montantTotal;
  final StatutCommande statut;
  final DateTime? dateCommande;

  Commande({
    required this.commandeId,
    String? numeroCommande,
    required this.utilisateurId,
    required this.adresseLivraison,
    this.montantTotal = 0,
    this.statut = StatutCommande.enAttente,
    required this.dateCommande,
  }) : numeroCommande = numeroCommande ?? commandeId;

  factory Commande.fromMap(Map<String, dynamic> map, String id) {
    final numero = _textValue(map['numeroCommande']) ??
        _textValue(map['numero']) ??
        _textValue(map['numero de commande']) ??
        id;

    return Commande(
      commandeId: id,
      numeroCommande: numero.isEmpty ? id : numero,
      utilisateurId: map['utilisateurId'] ?? '',
      adresseLivraison: map['adresseLivraison'] ?? '',
      montantTotal: (map['montantTotal'] as num?)?.toDouble() ?? 0,
      statut: StatutCommande.fromString(map['statut'] as String?),
      dateCommande: _dateFromValue(map['dateCommande']),
    );
  }

  factory Commande.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Commande.fromMap(doc.data() ?? {}, doc.id);
  }

  factory Commande.fromJson(Map<String, dynamic> data) {
    return Commande.fromMap(data, data['commandeId'] as String? ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'utilisateurId': utilisateurId,
      'numeroCommande': numeroCommande,
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
    String? numeroCommande,
    String? utilisateurId,
    String? adresseLivraison,
    double? montantTotal,
    StatutCommande? statut,
    DateTime? dateCommande,
  }) {
    return Commande(
      commandeId: commandeId ?? this.commandeId,
      numeroCommande: numeroCommande ?? this.numeroCommande,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      adresseLivraison: adresseLivraison ?? this.adresseLivraison,
      montantTotal: montantTotal ?? this.montantTotal,
      statut: statut ?? this.statut,
      dateCommande: dateCommande ?? this.dateCommande,
    );
  }

  static DateTime? _dateFromValue(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static String? _textValue(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
