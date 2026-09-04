import 'package:flutter/material.dart';

import '../core/constants/AppColors.dart';
import '../core/constants/AppFontSize.dart';

/// Petit badge arrondi utilisé pour afficher une étiquette : tranche d'âge,
/// catégorie, compétence, etc. (ex: "4-6 ans", "Educatif", "Logique").
///
/// Purement visuel, pas de logique de sélection — pour des chips
/// sélectionnables (filtres), voir [AgeFilterChips].
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.bold = true,
  });

  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.chipBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppFontSize.small,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
    );
  }
}
