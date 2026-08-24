import 'package:flutter/material.dart';

import '../core/constants/AppColors.dart';
import '../core/constants/AppFontSize.dart';
import '../core/constants/AppSpacing.dart';

/// Rangée de chips filtrables dont une seule peut être sélectionnée à la
/// fois (ex: "Tous" / "4-6 ans" / "7-9 ans" / "10-12 ans").
///
/// Générique : ne connaît rien du modèle Jouet, fonctionne avec n'importe
/// quelle liste de libellés.
class SelectableFilterChips extends StatelessWidget {
  const SelectableFilterChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  /// Libellés des filtres, dans l'ordre d'affichage (ex: ['Tous', '4-6 ans', ...]).
  final List<String> options;

  /// Libellé actuellement sélectionné (doit correspondre à une valeur de [options]).
  final String selected;

  /// Appelé avec le libellé choisi lorsqu'une chip est tapée.
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((option) {
          final isSelected = option == selected;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => onSelected(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: AppFontSize.small,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
