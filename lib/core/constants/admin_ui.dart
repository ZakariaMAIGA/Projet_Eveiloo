import 'package:flutter/material.dart';

/// Palette et constantes visuelles du back-office admin.
/// Reprend les couleurs de la maquette (bleu principal, fond gris clair,
/// cartes blanches arrondies avec ombre légère).
class AdminColors {
  AdminColors._();

  static const Color primary = Color(0xFF3B82F6); // Bleu "Statistiques"
  static const Color primaryDark = Color(0xFF2563EB);
  static const Color background = Color(0xFFF3F5F9);
  static const Color card = Colors.white;
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color success = Color(0xFF22C55E);
  static const Color pink = Color(0xFFEC4899);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color orange = Color(0xFFF59E0B);
  static const Color border = Color(0xFFE5E7EB);
}

class AdminRadius {
  AdminRadius._();
  static const double card = 20;
  static const double field = 14;
  static const double button = 14;
}

List<BoxShadow> get adminCardShadow => [
  BoxShadow(
    color: Colors.black.withOpacity(0.04),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

/// Carte blanche arrondie standard, utilisée partout dans l'admin.
class AdminCard extends StatelessWidget {
  const AdminCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AdminColors.card,
        borderRadius: BorderRadius.circular(AdminRadius.card),
        boxShadow: adminCardShadow,
      ),
      child: child,
    );
  }
}

/// Carte "statistique" du dashboard : icône colorée + valeur + libellé.
class AdminStatCard extends StatelessWidget {
  const AdminStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isLoading = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 14),
          isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AdminColors.textDark,
                  ),
                ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color: AdminColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Titre de section avec éventuel lien "voir tout".
class AdminSectionTitle extends StatelessWidget {
  const AdminSectionTitle({super.key, required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AdminColors.textDark,
          ),
        ),
        if (onSeeAll != null)
          TextButton(onPressed: onSeeAll, child: const Text('Voir tout')),
      ],
    );
  }
}

/// Bouton principal plein largeur (bleu), utilisé dans tous les formulaires.
class AdminPrimaryButton extends StatelessWidget {
  const AdminPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AdminColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AdminRadius.button),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Champ de texte standard des formulaires admin (label + champ arrondi).
class AdminTextField extends StatelessWidget {
  const AdminTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AdminColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AdminColors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminRadius.field),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminRadius.field),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminRadius.field),
              borderSide: const BorderSide(
                color: AdminColors.primary,
                width: 1.4,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Menu déroulant standard des formulaires admin.
class AdminDropdownField<T> extends StatelessWidget {
  const AdminDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AdminColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AdminColors.background,
            borderRadius: BorderRadius.circular(AdminRadius.field),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
