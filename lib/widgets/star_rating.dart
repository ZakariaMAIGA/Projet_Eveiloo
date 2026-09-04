import 'package:flutter/material.dart';

import '../core/constants/AppColors.dart';
import '../core/constants/AppFontSize.dart';

/// Affiche une note sous forme d'étoiles (pleines / vides), avec en option
/// la valeur numérique et le nombre d'avis à côté.
///
/// Exemple : ★★★☆☆  4,5 (120 avis)
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.starSize = 20,
    this.reviewCount,
    this.showValue = false,
  });

  /// Note actuelle (ex: 4.5), sur une échelle de [maxStars].
  final double rating;

  /// Nombre total d'étoiles affichées.
  final int maxStars;

  /// Taille (en pixels) de chaque étoile.
  final double starSize;

  /// Nombre d'avis à afficher entre parenthèses (ex: 120 -> "(120 avis)").
  /// Si `null`, rien n'est affiché après les étoiles.
  final int? reviewCount;

  /// Si `true`, affiche la valeur numérique (ex: "4,5") avant le texte d'avis.
  final bool showValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(maxStars, (index) {
          final seuil = index + 1;
          IconData icon;
          if (rating >= seuil) {
            icon = Icons.star;
          } else if (rating > index && rating < seuil) {
            icon = Icons.star_half;
          } else {
            icon = Icons.star_border;
          }
          return Icon(
            icon,
            size: starSize,
            color: rating > index ? AppColors.starFilled : AppColors.starEmpty,
          );
        }),
        if (showValue || reviewCount != null) const SizedBox(width: 6),
        if (showValue)
          Text(
            rating.toStringAsFixed(1).replaceAll('.', ','),
            style: const TextStyle(
              fontSize: AppFontSize.small,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        if (reviewCount != null)
          Text(
            showValue ? ' ($reviewCount avis)' : '($reviewCount avis)',
            style: const TextStyle(
              fontSize: AppFontSize.small,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }
}
