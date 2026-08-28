import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/cart_model.dart';
import '../../widgets/cart_item_card.dart';
import 'cart_service.dart';

/// ============================================================
/// PROVIDER DU SERVICE PANIER
/// ============================================================

final cartServiceProvider = Provider<CartService>((ref) {
  return CartService();
});

/// ============================================================
/// PROVIDER DU PANIER
/// ============================================================
///
/// Il récupère automatiquement le panier correspondant
/// à l'utilisateurId et écoute les changements Firestore
/// en temps réel.
///

final cartProvider =
    StreamProvider.family<List<CartItemModel>, String>(
  (ref, utilisateurId) {
    final cartService = ref.watch(cartServiceProvider);

    return cartService.streamPanier(utilisateurId);
  },
);

/// ============================================================
/// PAGE DU PANIER
/// ============================================================

class CartPage extends ConsumerWidget {
  final String utilisateurId;

  const CartPage({
    super.key,
    required this.utilisateurId,
  });

  /// ==========================================================
  /// FORMATAGE DU TOTAL
  /// ==========================================================

  String _formaterTotal(double total) {
    final chaine = total.toInt().toString();

    final buffer = StringBuffer();

    for (int i = 0; i < chaine.length; i++) {
      final positionDepuisFin = chaine.length - i;

      if (i != 0 && positionDepuisFin % 3 == 0) {
        buffer.write('.');
      }

      buffer.write(chaine[i]);
    }

    return '${buffer.toString()}F';
  }

  /// ==========================================================
  /// MODIFIER LA QUANTITE
  /// ==========================================================

  Future<void> _modifierQuantite(
    WidgetRef ref,
    CartItemModel item,
    int nouvelleQuantite,
  ) async {
    final cartService = ref.read(cartServiceProvider);

    try {
      await cartService.modifierQuantite(
        utilisateurId: utilisateurId,
        articlePanierId: item.articlePanierId,
        nouvelleQuantite: nouvelleQuantite,
      );
    } catch (e) {
      debugPrint('Erreur modification quantité : $e');
    }
  }

  /// ==========================================================
  /// SUPPRIMER UN ARTICLE
  /// ==========================================================

  Future<void> _supprimerArticle(
    WidgetRef ref,
    CartItemModel item,
  ) async {
    final cartService = ref.read(cartServiceProvider);

    try {
      await cartService.supprimerArticle(
        utilisateurId: utilisateurId,
        articlePanierId: item.articlePanierId,
      );
    } catch (e) {
      debugPrint('Erreur suppression article : $e');
    }
  }

  /// ==========================================================
  /// PASSER LA COMMANDE
  /// ==========================================================

  void _passerLaCommande(
    BuildContext context,
    List<CartItemModel> panier,
  ) {
    if (panier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ton panier est vide.'),
        ),
      );

      return;
    }

    // TODO :
    // Créer ici la commande avec order_service.dart
    // puis vider le panier.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Commande en cours de traitement...'),
      ),
    );
  }

  /// ==========================================================
  /// BUILD
  /// ==========================================================

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    /// Écoute le panier de l'utilisateur
    final panierAsync = ref.watch(
      cartProvider(utilisateurId),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      body: SafeArea(
        bottom: false,

        child: panierAsync.when(

          /// ----------------------------------------------------
          /// CHARGEMENT
          /// ----------------------------------------------------

          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },

          /// ----------------------------------------------------
          /// ERREUR
          /// ----------------------------------------------------

          error: (error, stackTrace) {
            debugPrint('Erreur panier : $error');

            return const Center(
              child: Text(
                'Une erreur est survenue.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            );
          },

          /// ----------------------------------------------------
          /// DONNEES
          /// ----------------------------------------------------

          data: (panier) {
            /// Calcul du total
            final total = panier.fold<double>(
              0,
              (sum, item) => sum + item.sousTotal,
            );

            return Column(
              children: [

                /// =================================================
                /// TITRE
                /// =================================================

                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    16,
                    20,
                    8,
                  ),

                  child: Align(
                    alignment: Alignment.centerLeft,

                    child: Text(
                      'Mon panier',

                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D9BE9),
                      ),
                    ),
                  ),
                ),

                /// =================================================
                /// LISTE DU PANIER
                /// =================================================

                Expanded(
                  child: panier.isEmpty

                      /// Panier vide
                      ? const Center(
                          child: Text(
                            'Ton panier est vide.',

                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        )

                      /// Panier avec articles
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                          ),

                          itemCount: panier.length,

                          itemBuilder: (
                            context,
                            index,
                          ) {
                            final item = panier[index];

                            return CartItemCard(
                              item: item,

                              /// Modifier quantité
                              onQuantiteChanged: (q) {
                                _modifierQuantite(
                                  ref,
                                  item,
                                  q,
                                );
                              },

                              /// Supprimer article
                              onSupprimer: () {
                                _supprimerArticle(
                                  ref,
                                  item,
                                );
                              },
                            );
                          },
                        ),
                ),

                /// =================================================
                /// TOTAL
                /// =================================================

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    12,
                  ),

                  child: Container(
                    width: double.infinity,

                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xFF7FCBF5),

                      borderRadius:
                          BorderRadius.circular(24),
                    ),

                    child: Center(
                      child: Text(
                        'Total :   ${_formaterTotal(total)}',

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),

                /// =================================================
                /// BOUTON PASSER LA COMMANDE
                /// =================================================

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    16,
                  ),

                  child: SizedBox(
                    width: double.infinity,
                    height: 52,

                    child: ElevatedButton(
                      onPressed: panier.isEmpty
                          ? null
                          : () {
                              _passerLaCommande(
                                context,
                                panier,
                              );
                            },

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF3D9BE9),

                        disabledBackgroundColor:
                            Colors.grey.shade300,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(26),
                        ),

                        elevation: 0,
                      ),

                      child: const Text(
                        'Passer la commande',

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}