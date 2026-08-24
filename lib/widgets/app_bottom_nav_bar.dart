import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.inactiveIcon,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      showUnselectedLabels: true,
      onTap: (index) {
        // Navigation à implémenter plus tard
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Accueil',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_outline),
          label: 'Tutoriel',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.toys_outlined),
          label: 'Catalogue',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.child_friendly_outlined),
          label: 'Activité',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}