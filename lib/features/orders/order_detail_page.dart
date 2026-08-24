import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../widgets/order_card.dart';

/// Détail d'une commande. Écran simple pour l'instant (pas de maquette
/// fournie) : affiche le récapitulatif via [OrderCard] et les informations
/// de livraison / paiement.
class OrderDetailPage extends StatelessWidget {
  final Commande commande;

  const OrderDetailPage({super.key, required this.commande});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Text('Commande ${commande.numeroAffiche}'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        children: [
          OrderCard(commande: commande),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Livraison',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    commande.adresseLivraison.isEmpty
                        ? 'Adresse non renseignée'
                        : commande.adresseLivraison,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  if (commande.methodePaiement != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Méthode de paiement',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      commande.methodePaiement!,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
