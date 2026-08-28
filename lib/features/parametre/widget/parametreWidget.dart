import 'package:eveiloo_enfant/core/constants/AppFontSize.dart';
import 'package:eveiloo_enfant/core/constants/AppSpacing.dart';
import 'package:flutter/material.dart';

class ParametreTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;
  final Color? iconColor;

  const ParametreTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: (iconColor ?? Colors.deepPurple).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? Colors.deepPurple, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: AppFontSize.medium,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText!,
              style: TextStyle(
                fontSize: AppFontSize.small,
                color: Colors.grey.shade600,
              ),
            ),
          if (trailingText != null) AppSpacing.horizontalGapSm,
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey.shade400,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}