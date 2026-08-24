import 'package:flutter/material.dart';

import '../core/constants/AppColors.dart';
import '../core/constants/AppFontSize.dart';
import '../core/constants/AppSpacing.dart';

/// Grand bouton arrondi bleu, plein largeur, utilisé pour les actions
/// principales d'un écran (ex: "Ajouter aux favoris", "Valider").
///
/// Gère un état [isLoading] (spinner) et un état [isActive] pour les
/// boutons "toggle" (ex: déjà ajouté aux favoris -> libellé/couleur différents).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isActive = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  /// `false` pour un état visuel "désactivé/déjà fait" (ex: fond gris clair).
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? AppColors.primary : AppColors.chipBackground,
          foregroundColor: isActive ? AppColors.white : AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: AppFontSize.medium,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
