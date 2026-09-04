import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/AppSpacing.dart';
import '../../models/cart_model.dart';
import '../../repository/commande_repository.dart';
import '../../routes/app_route.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItemModel> articles;

  const CheckoutPage({Key? key, required this.articles}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final CommandeRepository _commandeRepository = CommandeRepository();
  final TextEditingController _adresseController = TextEditingController();
  final FocusNode _adresseFocus = FocusNode();
  bool _isSubmitting = false;

  double get _total =>
      widget.articles.fold(0, (sum, item) => sum + item.sousTotal);

  @override
  void dispose() {
    _adresseController.dispose();
    _adresseFocus.dispose();
    super.dispose();
  }

  Future<void> _confirmerCommande() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (_adresseController.text.trim().isEmpty) {
      _adresseFocus.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir une adresse de livraison.'),
        ),
      );
      return;
    }
    if (userId == null) return;

    setState(() => _isSubmitting = true);
    try {
      final commandeId = await _commandeRepository.creerCommande(
        utilisateurId: userId,
        adresseLivraison: _adresseController.text.trim(),
        articlesPanier: widget.articles,
      );

      if (mounted) {
        context.pushReplacement('${AppRoutes.commandes}/$commandeId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la commande.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Finaliser la commande'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // --- RÉCAPITULATIF DES ARTICLES ---
            _SectionCard(
              titre: 'Récapitulatif',
              icon: Icons.shopping_bag_outlined,
              child: Column(
                children: [
                  for (final item in widget.articles) ...[
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 48,
                            height: 48,
                            color: Colors.grey.shade100,
                            child: item.urlImage.isNotEmpty
                                ? Image.network(
                                    item.urlImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.smart_toy_rounded,
                                      color: Colors.grey,
                                    ),
                                  )
                                : const Icon(
                                    Icons.smart_toy_rounded,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nom,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${item.quantite} × ${item.prixUnitaire.toInt()} FCFA',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${item.sousTotal.toInt()} FCFA',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (item != widget.articles.last)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1),
                      ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // --- ADRESSE DE LIVRAISON ---
            _SectionCard(
              titre: 'Adresse de livraison',
              icon: Icons.location_on_outlined,
              child: TextField(
                controller: _adresseController,
                focusNode: _adresseFocus,
                maxLines: 3,
                minLines: 2,
                decoration: InputDecoration(
                  hintText: 'Quartier, rue, ville, indications utiles...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF29B6F6),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // --- MODE DE PAIEMENT (indicatif, paiement à la livraison) ---
            _SectionCard(
              titre: 'Paiement',
              icon: Icons.payments_outlined,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF29B6F6).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined,
                      color: Color(0xFF29B6F6),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Paiement à la livraison',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),

      // --- BARRE TOTAL + CONFIRMATION FIXE ---
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: AppSpacing.md + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total à payer',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  Text(
                    '${_total.toInt()} FCFA',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF29B6F6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF29B6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _confirmerCommande,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Confirmer la commande',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String titre;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.titre,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF29B6F6)),
              const SizedBox(width: 8),
              Text(
                titre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
