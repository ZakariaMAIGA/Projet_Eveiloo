import 'package:eveiloo_enfant/features/cart/cart_service.dart';
import 'package:eveiloo_enfant/models/toy_model.dart';
import 'package:eveiloo_enfant/core/constants/AppSpacing.dart';
import 'package:eveiloo_enfant/core/constants/AppFontSize.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../models/cart_model.dart';
import '../../repository/toy_repository.dart';
import '../../routes/app_route.dart';

class ToyDetailPage extends StatefulWidget {
  final String toyId;

  const ToyDetailPage({Key? key, required this.toyId}) : super(key: key);

  @override
  State<ToyDetailPage> createState() => _ToyDetailPageState();
}

class _ToyDetailPageState extends State<ToyDetailPage> {
  final CartService _cartService = CartService();
  final ToyRepository _toyRepository = ToyRepository();
  final PageController _pageController = PageController();
  bool _isAdding = false;
  int _currentImage = 0;

  String? _getUserId() => FirebaseAuth.instance.currentUser?.uid;

  List<String> _imagesFor(ToyModel toy) {
    if (toy.images.isNotEmpty) return toy.images;
    if (toy.imageUrl.isNotEmpty) return [toy.imageUrl];
    return [];
  }

  Future<void> _addToCart(ToyModel toy) async {
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
      articlePanierId: '',
      jouetId: toy.id,
      nom: toy.nom,
      prixUnitaire: toy.prix,
      quantite: 1,
      urlImage: toy.imageUrl,
    );

    try {
      await _cartService.ajouterArticle(utilisateurId: userId, article: item);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Jouet ajouté au panier'),
            action: SnackBarAction(
              label: 'Voir le panier',
              onPressed: () => context.pushNamed(AppRoutes.cartName),
            ),
          ),
        );
      }
    } catch (e, stack) {
      debugPrint('Erreur ajout panier: $e');
      debugPrint('Stack: $stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'ajout au panier')),
        );
      }
    } finally {
      if (mounted) setState(() => _isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: StreamBuilder<ToyModel?>(
        stream: _toyRepository.streamToy(widget.toyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur lors du chargement du jouet.',
                style: TextStyle(color: Colors.red.shade700),
              ),
            );
          }

          final toy = snapshot.data;
          if (toy == null) {
            return const Center(child: Text('Jouet introuvable.'));
          }

          final images = _imagesFor(toy);

          return CustomScrollView(
            slivers: [
              // --- APPBAR AVEC IMAGE EN CARROUSEL ---
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    tooltip: 'Voir le panier',
                    onPressed: () => context.pushNamed(AppRoutes.cartName),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      images.isEmpty
                          ? Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(
                                  Icons.smart_toy_rounded,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : PageView.builder(
                              controller: _pageController,
                              itemCount: images.length,
                              onPageChanged: (index) =>
                                  setState(() => _currentImage = index),
                              itemBuilder: (context, index) {
                                return Image.network(
                                  images[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint('❌ Erreur image: $error');
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(
                                          Icons.smart_toy_rounded,
                                          size: 80,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                      if (images.length > 1)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(images.length, (index) {
                              final isActive = index == _currentImage;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                width: isActive ? 20 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              );
                            }),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // --- CONTENU ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              toy.nom,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '${toy.prix.toInt()} FCFA',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF29B6F6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          _buildStarRating(toy.note),
                          const SizedBox(width: 6),
                          Text(
                            '${toy.note.toStringAsFixed(1)} (${toy.nombreAvis} avis)',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: AppFontSize.small,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.cake_outlined,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Âge : ${toy.ageRange}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: AppFontSize.small,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (toy.tags.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: toy.tags
                              .map(
                                (tag) => Chip(
                                  label: Text(tag),
                                  labelStyle: const TextStyle(
                                    fontSize: AppFontSize.caption,
                                    color: Color(0xFF29B6F6),
                                  ),
                                  backgroundColor: const Color(
                                    0xFF29B6F6,
                                  ).withOpacity(0.1),
                                  side: BorderSide.none,
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppFontSize.medium,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        toy.description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.5,
                          fontSize: AppFontSize.medium,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (toy.competences.isNotEmpty) ...[
                        const Text(
                          'Compétences développées',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSize.medium,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: toy.competences
                              .map(
                                (competence) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.pink.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.pink.shade100,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.psychology_outlined,
                                        size: 14,
                                        color: Colors.pink.shade400,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        competence,
                                        style: TextStyle(
                                          fontSize: AppFontSize.caption,
                                          color: Colors.pink.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // --- BARRE D'ACTION FIXE EN BAS ---
      bottomNavigationBar: StreamBuilder<ToyModel?>(
        stream: _toyRepository.streamToy(widget.toyId),
        builder: (context, snapshot) {
          final toy = snapshot.data;
          return Container(
            padding: EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.sm,
              bottom: AppSpacing.sm + MediaQuery.of(context).padding.bottom,
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
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF29B6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: (_isAdding || toy == null)
                      ? null
                      : () => _addToCart(toy),
                  icon: _isAdding
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.shopping_cart, color: Colors.white),
                  label: Text(
                    _isAdding ? 'Ajout en cours...' : 'Ajouter au panier',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSize.medium,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    final fullStars = rating.floor();
    final hasHalfStar = (rating - fullStars) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData icon;
        if (index < fullStars) {
          icon = Icons.star_rounded;
        } else if (index == fullStars && hasHalfStar) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_border_rounded;
        }
        return Icon(icon, color: Colors.amber, size: 16);
      }),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
