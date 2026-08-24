import 'package:flutter/material.dart';
import '../models/order_model.dart';

/// Carte "Commande #XXXX" affichée dans la liste de l'écran Mes Commandes.
class OrderCard extends StatelessWidget {
  final Commande commande;
  final VoidCallback? onTap;

  const OrderCard({super.key, required this.commande, this.onTap});

  String _formaterPrix(double prix) {
    final chaine = prix.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < chaine.length; i++) {
      final positionDepuisFin = chaine.length - i;
      if (i != 0 && positionDepuisFin % 3 == 0) buffer.write(' ');
      buffer.write(chaine[i]);
    }
    return '${buffer.toString()} F';
  }

  String _formaterDate(DateTime date) {
    final j = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$j/$m/${date.year}';
  }

  _StyleStatut get _style {
    switch (commande.statut) {
      case StatutCommande.enCours:
        return _StyleStatut(
          fond: const Color(0xFFFFF1C2),
          texte: const Color(0xFFC98A00),
        );
      case StatutCommande.livree:
        return _StyleStatut(
          fond: const Color(0xFFD9F5DE),
          texte: const Color(0xFF2E9E5B),
        );
      case StatutCommande.annulee:
        return _StyleStatut(
          fond: const Color(0xFFE24C4C),
          texte: Colors.white,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commande ${commande.numeroAffiche}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3D9BE9),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formaterPrix(commande.montantTotal),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: style.fond,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    commande.statut.libelle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: style.texte,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formaterDate(commande.dateCommande),
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StyleStatut {
  final Color fond;
  final Color texte;

  _StyleStatut({required this.fond, required this.texte});
}
