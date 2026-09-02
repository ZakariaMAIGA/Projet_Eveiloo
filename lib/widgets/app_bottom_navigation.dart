import 'package:eveiloo_enfant/core/constants/AppRadius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  // Helper pour éviter la répétition du code SVG
  Widget _buildSvgIcon({
    required String assetName,
    required bool isSelected,
    required ThemeData theme,
  }) {
    final Color color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return SvgPicture.asset(
      assetName,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: navigationShell,
      backgroundColor: Colors.white,
      bottomNavigationBar: NavigationBar(
        indicatorShape: RoundedRectangleBorder(
          borderRadius: Appradius.borderRadiusSm,
        ),
        backgroundColor: Colors.white,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: [
          NavigationDestination(
            icon: _buildSvgIcon(
              assetName: "assets/icons/accueil.svg",
              isSelected: false,
              theme: theme,
            ),
            selectedIcon: _buildSvgIcon(
              assetName: "assets/icons/accueil.svg",
              isSelected: true,
              theme: theme,
            ),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: _buildSvgIcon(
              assetName: "assets/icons/tutoriel.svg",
              isSelected: false,
              theme: theme,
            ),
            selectedIcon: _buildSvgIcon(
              assetName: "assets/icons/tutoriel.svg",
              isSelected: true,
              theme: theme,
            ),
            label: 'Tutoriels',
          ),
          NavigationDestination(
            icon: _buildSvgIcon(
              assetName: "assets/icons/catalogue.svg",
              isSelected: false,
              theme: theme,
            ),
            selectedIcon: _buildSvgIcon(
              assetName: "assets/icons/catalogue.svg",
              isSelected: true,
              theme: theme,
            ),
            label: 'Catalogues',
          ),
          NavigationDestination(
            icon: _buildSvgIcon(
              assetName: "assets/icons/activites.svg",
              isSelected: false,
              theme: theme,
            ),
            selectedIcon: _buildSvgIcon(
              assetName: "assets/icons/activites.svg",
              isSelected: true,
              theme: theme,
            ),
            label: 'Activités',
          ),
          NavigationDestination(
            icon: _buildSvgIcon(
              assetName: "assets/icons/personne.svg",
              isSelected: false,
              theme: theme,
            ),
            selectedIcon: _buildSvgIcon(
              assetName: "assets/icons/personne.svg",
              isSelected: true,
              theme: theme,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
