import 'package:flutter/material.dart';

import '../core/constants/AppColors.dart';
import '../core/constants/AppFontSize.dart';
import '../core/constants/AppSpacing.dart';
import '../models/jouetModel.dart';

/// Ligne présentant un jouet mis en favori : image, nom, étoile pour retirer
/// le favori, bouton "Voir le jouet" et prix — tel que sur la maquette
/// "Mes Favoris".
class FavoriToyRow extends StatelessWidget {
  const FavoriToyRow({
    super.key,
    required this.jouet,
    required this.onVoirLeJouet,
    required this.onRetirerDesFavoris,
  });

  final JouetModel jouet;
  final VoidCallback onVoirLeJouet;
  final VoidCallback onRetirerDesFavoris;

  String get _prixFormate => '${jouet.prix.toStringAsFixed(0)}CFA';

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 72,
            height: 72,
            child: jouet.images.isNotEmpty
                ? Image.network(
                    jouet.images,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _imagePlaceholder(),
                  )
                : _imagePlaceholder(),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      jouet.nom,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: AppFontSize.medium,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onRetirerDesFavoris,
                    child: const Padding(
                      padding: EdgeInsets.only(left: AppSpacing.sm),
                      child: Icon(
                        Icons.star,
                        color: AppColors.starFilled,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: onVoirLeJouet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.starFilled,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Voir le jouet',
                      style: TextStyle(
                        fontSize: AppFontSize.small,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _prixFormate,
                    style: const TextStyle(
                      fontSize: AppFontSize.medium,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.chipBackground,
      child: const Icon(Icons.toys, color: AppColors.textSecondary),
    );
  }
}
