import 'package:flutter/material.dart';
import '../../core/services/payment_service.dart';
import '../../models/payment_model.dart';
import '../../widgets/payement_method_card.dart';
import 'orders_page.dart';

enum _EtapePaiement { choixMethode, codeSecret, confirmation }

/// Écran de paiement "light" en 3 étapes, tel que dans la maquette
/// "20- Paiement light" :
///  1. Choix de la méthode (Orange Money, Moov Money, carte, espèces)
///  2. Saisie du montant + code secret (mobile money)
///  3. Confirmation "Paiement validé avec succès"
class CheckoutPage extends StatefulWidget {
  final String utilisateurId;
  final double montant;
  final String adresseLivraison;

  const CheckoutPage({
    super.key,
    required this.utilisateurId,
    required this.montant,
    required this.adresseLivraison,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final PaymentService _paymentService = PaymentService();
  final TextEditingController _codeController = TextEditingController();

  _EtapePaiement _etape = _EtapePaiement.choixMethode;
  MethodePaiement _methodeSelectionnee = MethodePaiement.orangeMoney;
  bool _enCours = false;
  String? _erreur;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String _formaterMontant(double montant) {
    final chaine = montant.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < chaine.length; i++) {
      final positionDepuisFin = chaine.length - i;
      if (i != 0 && positionDepuisFin % 3 == 0) buffer.write('.');
      buffer.write(chaine[i]);
    }
    return '${buffer.toString()}F';
  }

  void _choisirMethode(MethodePaiement methode) {
    setState(() {
      _methodeSelectionnee = methode;
      _erreur = null;
      // Carte bancaire et espèces n'exigent pas de code secret ici :
      // on part directement à la confirmation (le paiement carte / espèces
      // "light" est simulé comme immédiatement pris en compte).
      _etape = methode.necessiteCodeSecret
          ? _EtapePaiement.codeSecret
          : _EtapePaiement.confirmation;
    });

    if (!methode.necessiteCodeSecret) {
      _validerPaiement();
    }
  }

  Future<void> _validerPaiement() async {
    if (_methodeSelectionnee.necessiteCodeSecret &&
        !_paymentService.codeSecretValide(_codeController.text)) {
      setState(() => _erreur = 'Entre un code secret valide.');
      return;
    }

    setState(() {
      _enCours = true;
      _erreur = null;
    });

    final resultat = await _paymentService.effectuerPaiement(
      utilisateurId: widget.utilisateurId,
      adresseLivraison: widget.adresseLivraison,
      montant: widget.montant,
      methode: _methodeSelectionnee,
      codeSecret: _codeController.text,
    );

    if (!mounted) return;

    setState(() => _enCours = false);

    if (resultat.succes) {
      setState(() => _etape = _EtapePaiement.confirmation);
    } else {
      setState(() => _erreur = resultat.messageErreur);
    }
  }

  void _fermerConfirmation() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OrdersPage(utilisateurId: widget.utilisateurId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: switch (_etape) {
            _EtapePaiement.choixMethode => _EtapeChoixMethode(
                key: const ValueKey('choixMethode'),
                methodeSelectionnee: _methodeSelectionnee,
                onChoisir: _choisirMethode,
              ),
            _EtapePaiement.codeSecret => _EtapeCodeSecret(
                key: const ValueKey('codeSecret'),
                montant: _formaterMontant(widget.montant),
                codeController: _codeController,
                enCours: _enCours,
                erreur: _erreur,
                onValider: _validerPaiement,
                onAnnuler: () =>
                    setState(() => _etape = _EtapePaiement.choixMethode),
              ),
            _EtapePaiement.confirmation => _EtapeConfirmation(
                key: const ValueKey('confirmation'),
                onFermer: _fermerConfirmation,
              ),
          },
        ),
      ),
    );
  }
}

class _EtapeChoixMethode extends StatelessWidget {
  final MethodePaiement methodeSelectionnee;
  final ValueChanged<MethodePaiement> onChoisir;

  const _EtapeChoixMethode({
    super.key,
    required this.methodeSelectionnee,
    required this.onChoisir,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Paiement',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3D9BE9),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Choisissez votre méthode',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          for (final methode in MethodePaiement.values)
            PayementMethodCard(
              methode: methode,
              selectionnee: methode == methodeSelectionnee,
              onTap: () => onChoisir(methode),
            ),
        ],
      ),
    );
  }
}

class _EtapeCodeSecret extends StatelessWidget {
  final String montant;
  final TextEditingController codeController;
  final bool enCours;
  final String? erreur;
  final VoidCallback onValider;
  final VoidCallback onAnnuler;

  const _EtapeCodeSecret({
    super.key,
    required this.montant,
    required this.codeController,
    required this.enCours,
    required this.erreur,
    required this.onValider,
    required this.onAnnuler,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black26),
            ),
            child: Text(
              'Montant a payer:  $montant',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: codeController,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Entrez votre code secret',
              hintStyle: const TextStyle(color: Colors.black38),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black26),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black26),
              ),
            ),
          ),
          if (erreur != null) ...[
            const SizedBox(height: 8),
            Text(
              erreur!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: enCours ? null : onValider,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D9BE9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: enCours
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Valider',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: enCours ? null : onAnnuler,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF3D9BE9)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(
                        color: Color(0xFF3D9BE9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EtapeConfirmation extends StatelessWidget {
  final VoidCallback onFermer;

  const _EtapeConfirmation({super.key, required this.onFermer});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Paiement validé avec succès',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFD9F5DE),
          ),
          child: const Icon(Icons.check_rounded, color: Color(0xFF2E9E5B), size: 36),
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: onFermer,
          child: const Icon(Icons.close_rounded, color: Colors.black87, size: 24),
        ),
      ],
    );
  }
}
