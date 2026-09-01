import 'package:cloud_firestore/cloud_firestore.dart'; 

class Commande {
    final String? commandeId;
    final String utilisateurId;
    final String adresseLivraison;
    final double montantTotal;
    final String statut;
    final DateTime dateCommande;
    final String methodePaiement;
    final int? numero;

    Commande({
        this.commandeId,
        required this.utilisateurId,
        required this.adresseLivraison,
        required this.montantTotal,
        required this.statut,
        required this.dateCommande,
        required this.methodePaiement,
        required this.numero,
    });

    factory Commande.fromJson(Map<String, dynamic> json) {
        return Commande(
            commandeId: json['commandeId'],
            utilisateurId: json['utilisateurId'],
            adresseLivraison: json['adresseLivraison'],
            montantTotal: (json['montantTotal'] as num).toDouble(),
            statut: json['statut'],
            dateCommande: (json['dateCommande'] as Timestamp).toDate(),
            methodePaiement: json['methodePaiement'] ?? '',
            numero: json['numero'],
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'commandeId': commandeId,
            'utilisateurId': utilisateurId,
            'adresseLivraison': adresseLivraison,
            'montantTotal': montantTotal,
            'statut': statut,
            'dateCommande': Timestamp.fromDate(dateCommande),
            'methodePaiement': methodePaiement,
            'numero': numero,
        };
    }
    
    Commande copyWith({
        String? commandeId,
        String? utilisateurId,
        String? adresseLivraison,
        double? montantTotal,
        String? statut,
        DateTime? dateCommande,
        String? methodePaiement,
        int? numero,
    }) {
        return Commande(
            commandeId: commandeId ?? this.commandeId,
            utilisateurId: utilisateurId ?? this.utilisateurId,
            adresseLivraison: adresseLivraison ?? this.adresseLivraison,
            montantTotal: montantTotal ?? this.montantTotal,
            statut: statut ?? this.statut,
            dateCommande: dateCommande ?? this.dateCommande,
            methodePaiement: methodePaiement ?? this.methodePaiement,
            numero: numero ?? this.numero,
        );
    }
}