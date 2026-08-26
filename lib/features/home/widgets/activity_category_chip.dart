import 'package:flutter/material.dart';

/// Catégorie d'activité affichée en chip dans le home.
/// Ces valeurs doivent correspondre à `categorieCompetence` sur `Activite`.
class ActivityCategory {
  const ActivityCategory(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}

const List<ActivityCategory> kActivityCategories = [
  ActivityCategory('Logique', Icons.extension_rounded, Colors.deepPurple),
  ActivityCategory('Créativité', Icons.palette_rounded, Colors.orange),
  ActivityCategory('Motricité', Icons.directions_run_rounded, Colors.green),
  ActivityCategory('Langage', Icons.chat_bubble_rounded, Colors.blue),
  ActivityCategory('Social', Icons.groups_rounded, Colors.pink),
];

class ActivityCategoryChip extends StatelessWidget {
  const ActivityCategoryChip({super.key, required this.category, this.onTap});

  final ActivityCategory category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 84,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: category.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, color: category.color),
            const SizedBox(height: 6),
            Text(
              category.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: category.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
