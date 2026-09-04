import 'package:eveiloo_enfant/core/constants/AppRadius.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChildBottomNavigation extends StatelessWidget {
  const ChildBottomNavigation({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color actif = Color(0xFF6C63FF);
    const Color inactif = Colors.grey;

    return Scaffold(
      body: navigationShell,
      backgroundColor: const Color(0xFFF9FAFC),
      bottomNavigationBar: NavigationBar(
        indicatorShape: RoundedRectangleBorder(
          borderRadius: Appradius.borderRadiusSm,
        ),
        indicatorColor: actif.withOpacity(0.15),
        backgroundColor: Colors.white,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded, color: inactif),
            selectedIcon: Icon(Icons.home_rounded, color: actif),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined, color: inactif),
            selectedIcon: Icon(Icons.storefront_rounded, color: actif),
            label: 'Catalogue',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_display_outlined, color: inactif),
            selectedIcon: Icon(Icons.smart_display_rounded, color: actif),
            label: 'Tutoriels',
          ),
          NavigationDestination(
            icon: Icon(Icons.extension_outlined, color: inactif),
            selectedIcon: Icon(Icons.extension_rounded, color: actif),
            label: 'Activités',
          ),
        ],
      ),
    );
  }
}
