import 'package:eveiloo_enfant/core/constants/AppFontSize.dart';
import 'package:eveiloo_enfant/core/constants/AppSpacing.dart';
import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // nécessaire pour InkWell
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8), // arrondi du ripple
        splashColor: Colors.blue.withOpacity(0.2), // couleur au clic
        hoverColor: Colors.grey.withOpacity(
          0.1,
        ), // effet au survol (web/desktop)
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(
                icon,
                size: AppFontSize.extraLarge,
                color: iconColor ?? Colors.black87,
              ),

              AppSpacing.horizontalGapLg,

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppFontSize.large,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const Icon(Icons.chevron_right, size: 30, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}
