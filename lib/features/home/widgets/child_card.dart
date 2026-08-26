import 'package:flutter/material.dart';

import '../../../models/enfant.dart';

/// Carte compacte pour un enfant, affichée dans la liste horizontale
/// (scrollable) du home.
class ChildCard extends StatelessWidget {
  const ChildCard({
    super.key,
    required this.enfant,
    required this.accentColor,
    this.onTap,
  });

  final EnfantModel enfant;
  final Color accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Progression visuelle sur une échelle de 0 à 10 — à ajuster si le
    // barème réel de progression de l'app est différent.
    final progression = (enfant.niveauAtteint / 10).clamp(0.0, 1.0);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: accentColor.withOpacity(0.15),
              backgroundImage: enfant.urlAvatar.isNotEmpty
                  ? NetworkImage(enfant.urlAvatar)
                  : null,
              child: enfant.urlAvatar.isEmpty
                  ? Icon(Icons.face, color: accentColor, size: 28)
                  : null,
            ),
            const SizedBox(height: 10),
            Text(
              enfant.prenom,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: accentColor,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${enfant.age} ans',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              'Niveau ${enfant.niveauAtteint}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progression,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
