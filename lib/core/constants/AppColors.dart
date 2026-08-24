import 'package:flutter/material.dart';

/// Palette de couleurs de l'application, centralisée pour rester cohérent
/// avec les maquettes Figma.
class AppColors {
  // Bleu principal (boutons, éléments actifs, fond des carrousels)
  static const Color primary = Color(0xFF4FA8F5);
  static const Color primaryDark = Color(0xFF3B8FE0);

  // Fond bleu clair (carrousel d'images, chips inactives)
  static const Color lightBlueBackground = Color(0xFFCFE9FB);
  static const Color chipBackground = Color(0xFFD7EEFB);

  // Étoiles de notation
  static const Color starFilled = Color(0xFFFFA726);
  static const Color starEmpty = Color(0xFFE0E0E0);

  // Neutres
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color border = Color(0xFFE0E0E0);
  static const Color white = Color(0xFFFFFFFF);
}
