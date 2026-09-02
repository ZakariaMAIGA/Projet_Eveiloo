import 'package:eveiloo_enfant/core/constants/AppFontSize.dart';
import 'package:eveiloo_enfant/core/constants/AppSpacing.dart';
import 'package:eveiloo_enfant/features/cart/cart_service.dart';
import 'package:eveiloo_enfant/models/cart_model.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();

  String? _getUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    final userId = _getUserId();

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mon panier')),
        body: const Center(child: Text('Veuillez vous connecter.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Mon panier'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<List<CartItemModel>>(
        stream: _cartService.streamPanier(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur lors du chargement du panier.',
                style: TextStyle(color: Colors.red.shade700),
              ),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Text(
                'Votre panier est vide.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          double total = items.fold(0, (sum, item) => sum + item.sousTotal);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildCartItem(item, userId);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: AppFontSize.large,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${total.toInt()} FCFA',
                          style: const TextStyle(
                            fontSize: AppFontSize.large,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF29B6F6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push(
                            AppRoutes.checkout, // à ajouter dans app_route.dart
                            extra: items, // List<CartItemModel>
                          );
                        },
                        child: const Text('Passer la commande'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(CartItemModel item, String userId) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.urlImage.isNotEmpty
                  ? Image.network(
                      item.urlImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.smart_toy_rounded,
                        color: Colors.grey,
                        size: 32,
                      ),
                    )
                  : const Icon(
                      Icons.smart_toy_rounded,
                      color: Colors.grey,
                      size: 32,
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSize.medium,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.prixUnitaire.toInt()} FCFA / unité',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: AppFontSize.small,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _cartService.modifierQuantite(
                          utilisateurId: userId,
                          articlePanierId: item.articlePanierId,
                          nouvelleQuantite: item.quantite - 1,
                        );
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${item.quantite}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppFontSize.medium,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _cartService.modifierQuantite(
                          utilisateurId: userId,
                          articlePanierId: item.articlePanierId,
                          nouvelleQuantite: item.quantite + 1,
                        );
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        _cartService.supprimerArticle(
                          utilisateurId: userId,
                          articlePanierId: item.articlePanierId,
                        );
                      },
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${item.sousTotal.toInt()} FCFA',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppFontSize.medium,
              color: Color(0xFF29B6F6),
            ),
          ),
        ],
      ),
    );
  }
}
