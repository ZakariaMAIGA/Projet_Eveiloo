import 'package:flutter/material.dart';

import '../core/constants/AppColors.dart';
import '../core/constants/AppFontSize.dart';
import '../core/constants/AppSpacing.dart';
import 'star_rating.dart';

/// Carte présentant un jouet dans une liste (image, nom, note, prix).
///
/// Générique : ne dépend pas de `JouetModel`, prend des valeurs déjà
/// extraites en paramètres. Une fois le modèle final disponible, il suffira
/// de faire `ToyListCard(name: jouet.nom, price: jouet.prix, ...)`.
class ToyListCard extends StatelessWidget {
  const ToyListCard({
    super.key,
    required this.name,
    required this.rating,
    required this.price,
    this.image,
    this.onTap,
  });

  final String name;
  final double rating;

  /// Prix déjà formaté en texte (ex: "10.000F") pour rester flexible sur le
  /// format d'affichage (devise, séparateurs...).
  final String price;

  /// Widget d'image (ex: `Image.network(...)`). `null` affiche un espace réservé.
  final Widget? image;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 84,
                height: 84,
                child: image ??
                    Container(
                      color: AppColors.chipBackground,
                      child: const Icon(
                        Icons.toys,
                        color: AppColors.textSecondary,
                      ),
                    ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: AppFontSize.medium,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StarRating(rating: rating, starSize: 18),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: AppFontSize.medium,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
