import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/Commande.dart';

class CommandeCard extends StatelessWidget {
  final Commande commande;

  const CommandeCard({
    super.key,
    required this.commande,
  });

  Color _getStatusColor() {
    switch (commande.statut) {
      case StatutCommande.enAttente:
      case StatutCommande.confirmee:
      case StatutCommande.expediee:
        return Colors.orange;

      case StatutCommande.livree:
        return Colors.green;

      case StatutCommande.annulee:
        return Colors.red;

    }
  }

  String _getStatusText() {
    switch (commande.statut) {
      case StatutCommande.enAttente:
        return 'En attente';
      case StatutCommande.confirmee:
        return 'Confirmée';
      case StatutCommande.expediee:
        return 'Expédiée';
      case StatutCommande.livree:
        return 'Livrée';
      case StatutCommande.annulee:
        return 'Annulée';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor();

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => context.push('/commandes/${commande.commandeId}'),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
          /// Première ligne
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Commande #${commande.numeroCommande}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4E82B4),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// Montant et date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${commande.montantTotal.toStringAsFixed(0)} F',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                _formatDate(commande.dateCommande),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Date inconnue';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}