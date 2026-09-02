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

  /// Calcule l'âge à partir de dateNaissance (format attendu : YYYY-MM-DD).
  int _calculerAge() {
    final dateStr = enfant.dateNaissance;
    if (dateStr.isEmpty) return 0;

    try {
      final parts = dateStr.split('-');
      if (parts.length != 3) return 0;

      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      final now = DateTime.now();
      var age = now.year - year;

      // Si l'anniversaire n'est pas encore passé cette année
      if (now.month < month || (now.month == month && now.day < day)) {
        age--;
      }

      return age < 0 ? 0 : age;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progression = (enfant.niveauAtteint / 10).clamp(0.0, 1.0);
    final age = _calculerAge();

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
              '$age ans',
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
