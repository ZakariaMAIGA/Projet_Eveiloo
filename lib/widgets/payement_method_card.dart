import 'package:flutter/material.dart';
import '../models/payment_model.dart';

/// Ligne "méthode de paiement" affichée sur l'écran Paiement.
/// Reprend le style des cartes de l'app (fond blanc, coins arrondis,
/// légère ombre) avec un contour violet quand la méthode est sélectionnée.
class PayementMethodCard extends StatelessWidget {
  final MethodePaiement methode;
  final bool selectionnee;
  final VoidCallback onTap;

  const PayementMethodCard({
    super.key,
    required this.methode,
    required this.selectionnee,
    required this.onTap,
  });

  _MethodeVisuel get _visuel {
    switch (methode) {
      case MethodePaiement.orangeMoney:
        return _MethodeVisuel(
          icone: Icons.account_balance_wallet_rounded,
          couleur: const Color(0xFFFF7900),
        );
      case MethodePaiement.moovMoney:
        return _MethodeVisuel(
          icone: Icons.smartphone_rounded,
          couleur: const Color(0xFF0072CE),
        );
      case MethodePaiement.carteBancaire:
        return _MethodeVisuel(
          icone: Icons.credit_card_rounded,
          couleur: const Color(0xFFEB5757),
        );
      case MethodePaiement.especes:
        return _MethodeVisuel(
          icone: Icons.payments_rounded,
          couleur: const Color(0xFF2E9E5B),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final visuel = _visuel;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selectionnee ? const Color(0xFF8C52FF) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: visuel.couleur.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(visuel.icone, color: visuel.couleur, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                methode.libelle,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}

class _MethodeVisuel {
  final IconData icone;
  final Color couleur;

  _MethodeVisuel({required this.icone, required this.couleur});
}
