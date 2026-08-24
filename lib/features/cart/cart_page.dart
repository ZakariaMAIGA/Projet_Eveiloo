import 'package:flutter/material.dart';
import '../../models/cart_model.dart';
import '../../widgets/cart_item_card.dart';
import 'cart_service.dart';

class CartPage extends StatefulWidget {
  final String utilisateurId;

  const CartPage({super.key, required this.utilisateurId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();

  String _formaterTotal(double total) {
    final chaine = total.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < chaine.length; i++) {
      final positionDepuisFin = chaine.length - i;
      if (i != 0 && positionDepuisFin % 3 == 0) buffer.write('.');
      buffer.write(chaine[i]);
    }
    return '${buffer.toString()}F';
  }

  void _modifierQuantite(CartItemModel item, int nouvelleQuantite) {
    _cartService.modifierQuantite(
      utilisateurId: widget.utilisateurId,
      articlePanierId: item.articlePanierId,
      nouvelleQuantite: nouvelleQuantite,
    );
  }

  void _supprimerArticle(CartItemModel item) {
    _cartService.supprimerArticle(
      utilisateurId: widget.utilisateurId,
      articlePanierId: item.articlePanierId,
    );
  }

  void _passerLaCommande(CartModel panier) {
    if (panier.articles.isEmpty) return;
    // TODO : créer la commande (order_service.dart) puis vider le panier
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Commande en cours de traitement...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        bottom: false,
        child: StreamBuilder<CartModel>(
          stream: _cartService.streamPanier(widget.utilisateurId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Une erreur est survenue.'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final panier = snapshot.data!;

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
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
                Expanded(
                  child: panier.articles.isEmpty
                      ? const Center(child: Text('Ton panier est vide.'))
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          itemCount: panier.articles.length,
                          itemBuilder: (context, index) {
                            final item = panier.articles[index];
                            return CartItemCard(
                              item: item,
                              onQuantiteChanged: (q) =>
                                  _modifierQuantite(item, q),
                              onSupprimer: () => _supprimerArticle(item),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7FCBF5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        'Total:   ${_formaterTotal(panier.totalGeneral)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _passerLaCommande(panier),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3D9BE9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
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
