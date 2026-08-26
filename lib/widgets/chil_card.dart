import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/child_model.dart';

class ChildCard extends StatelessWidget {
  final ChildModel child;
  final Color progressColor;

  const ChildCard({
    super.key,
    required this.child,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 182,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 55,
              child: Icon(Icons.person),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            child.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF233B87),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '${child.age} ans',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.greyText,
            ),
          ),

          const SizedBox(height: 28),

          Text(
            'Niveau ${child.level}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: AppColors.darkText,
            ),
          ),


         
        ],
      ),
    );
  }
}