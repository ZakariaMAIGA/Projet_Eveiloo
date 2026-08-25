import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      backgroundColor: Colors.white,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: const [
          NavigationDestination(
            icon: Image(
              image: AssetImage('assets/logo/home.png'),
              width: 50,
              height: 50,
            ),
            selectedIcon: Image(
              image: AssetImage('assets/logo/home.png'),
              width: 50,
              height: 50,
            ),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Image(
              image: AssetImage('assets/logo/tuto.png'),
              width: 50,
              height: 50,
            ),
            selectedIcon: Image(
              image: AssetImage('assets/logo/tuto.png'),
              width: 50,
              height: 50,
            ),
            label: 'Tutoriels',
          ),
          NavigationDestination(
            icon: Image(
              image: AssetImage('assets/logo/catalogue.png'),
              width: 50,
              height: 50,
            ),
            selectedIcon: Image(
              image: AssetImage('assets/logo/catalogue.png'),
              width: 50,
              height: 50,
            ),
            label: 'Catalogues',
          ),
          NavigationDestination(
            icon: Image(
              image: AssetImage('assets/logo/activite.png'),
              width: 50,
              height: 50,
            ),
            selectedIcon: Image(
              image: AssetImage('assets/logo/activite.png'),
              width: 50,
              height: 50,
            ),
            label: 'Activités',
          ),

          NavigationDestination(
            icon: Image(
              image: AssetImage('assets/logo/person.png'),
              width: 50,
              height: 50,
            ),
            selectedIcon: Image(
              image: AssetImage('assets/logo/person.png'),
              width: 50,
              height: 50,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
