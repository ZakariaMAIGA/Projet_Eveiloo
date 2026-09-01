import 'package:eveiloo_enfant/features/cart/cart_service.dart';
import 'package:eveiloo_enfant/models/toy_model.dart';
import 'package:eveiloo_enfant/core/constants/AppSpacing.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/cart_model.dart'; // CartItemModel

class ToyDetailPage extends StatefulWidget {
  final ToyModel toy;

  const ToyDetailPage({Key? key, required this.toy}) : super(key: key);

  @override
  State<ToyDetailPage> createState() => _ToyDetailPageState();
}

class _ToyDetailPageState extends State<ToyDetailPage> {
  final CartService _cartService = CartService();
  bool _isAdding = false;

  String? _getUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _addToCart() async {
    final userId = _getUserId();
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez vous connecter pour ajouter au panier.'),
          ),
        );
      }
      return;
    }

    setState(() => _isAdding = true);

    final item = CartItemModel(
      articlePanierId: '', // ignoré, sera généré par Firestore
      jouetId: widget.toy.id,
      nom: widget.toy.nom,
      prixUnitaire: widget.toy.prix,
      quantite: 1,
      urlImage: widget.toy.imageUrl,
    );

    try {
      await _cartService.ajouterArticle(utilisateurId: userId, article: item);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Jouet ajouté au panier')));
      }
    } catch (e, stack) {
      // Pour déboguer : regarde la console
      debugPrint('Erreur ajout panier: $e');
      debugPrint('Stack: $stack');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l’ajout au panier')),
        );
      }
    } finally {
      if (mounted) setState(() => _isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final toy = widget.toy;

    return Scaffold(
      appBar: AppBar(title: Text(toy.nom)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE DU JOUET AVEC ICÔNE PAR DÉFAAUT
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 240,
                color: Colors.grey.shade200,
                child: toy.imageUrl.isNotEmpty
                    ? Image.network(
                        toy.imageUrl,
                        width: double.infinity,
                        height: 240,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.smart_toy_rounded,
                              size: 64,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(
                          Icons.smart_toy_rounded,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              toy.nom,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('${toy.prix.toInt()} FCFA'),
            Text('Âge : ${toy.ageRange}'),
            const SizedBox(height: AppSpacing.md),
            Text(toy.description),
            const SizedBox(height: AppSpacing.lg),

            // BOUTON AJOUTER AU PANIER
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isAdding ? null : _addToCart,
                icon: _isAdding
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.shopping_cart),
                label: Text(
                  _isAdding ? 'Ajout en cours...' : 'Ajouter au panier',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
