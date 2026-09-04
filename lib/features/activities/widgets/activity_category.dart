import 'package:flutter/material.dart';

class ActivityCategory {
  const ActivityCategory({required this.colors, required this.accent});

  final List<Color> colors;
  final Color accent;

  LinearGradient get gradient => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

ActivityCategory categoryStyle(String category) {
  final normalized = category.toLowerCase();
  if (normalized.contains('math')) {
    return const ActivityCategory(
      colors: [Color(0xFF16B9D4), Color(0xFF5DD45A), Color(0xFFF0D52D)],
      accent: Color(0xFF16A9CE),
    );
  }
  if (normalized.contains('cré') || normalized.contains('creat')) {
    return const ActivityCategory(
      colors: [Color(0xFF7656E8), Color(0xFFEF4E9D), Color(0xFFFF8B37)],
      accent: Color(0xFF40AD61),
    );
  }
  if (normalized.contains('log')) {
    return const ActivityCategory(
      colors: [Color(0xFF1D9BF0), Color(0xFF7A5AF8), Color(0xFF3CCB9A)],
      accent: Color(0xFF7656E8),
    );
  }
  return const ActivityCategory(
    colors: [Color(0xFF243BFF), Color(0xFFE91E9B), Color(0xFFFFA31A)],
    accent: Color(0xFF1118F5),
  );
}