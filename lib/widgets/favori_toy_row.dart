import 'package:eveiloo_enfant/core/constants/app_colors.dart';
import 'package:eveiloo_enfant/models/toy_model.dart';
import 'package:flutter/material.dart';

import '../core/constants/AppFontSize.dart';
import '../core/constants/AppSpacing.dart';

class FavoriToyRow extends StatelessWidget {
  const FavoriToyRow({
    super.key,
    required this.jouet,
    required this.onVoirLeJouet,
    required this.onRetirerDesFavoris,
  });

  final ToyModel jouet;
  final VoidCallback onVoirLeJouet;
  final VoidCallback onRetirerDesFavoris;

  String get _prixFormate {
    return '${jouet.prix.toStringAsFixed(0)} CFA';
  }

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
            child: jouet.imageUrl.isNotEmpty
                ? Image.network(
                    jouet.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _imagePlaceholder();
                    },
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
                    child: const Text('Voir le jouet'),
                  ),
                  const Spacer(),
                  Text(_prixFormate),
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
