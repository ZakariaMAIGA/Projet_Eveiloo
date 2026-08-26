
import 'package:eveiloo_enfant/models/activity_model.dart.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;

  const ActivityCard({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 14,
      ),
      child: Row(
        children: [
          // Image de l'activité
          Container(
            width: 78,
            height: 78,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              activity.imageUrl,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 20),

          // Informations de l'activité
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  activity.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}