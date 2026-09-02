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
  bool _isSubmitting = false;

  double get _total =>
      widget.articles.fold(0, (sum, item) => sum + item.sousTotal);

  Future<void> _confirmerCommande() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || _adresseController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir une adresse de livraison.'),
        ),
      );
      return;
    }

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
      appBar: AppBar(title: const Text('Livraison & paiement')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _adresseController,
              decoration: const InputDecoration(
                labelText: 'Adresse de livraison',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Total à payer : ${_total.toInt()} FCFA',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _confirmerCommande,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Confirmer la commande'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
