import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'profile_menu_item.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(45, 0, 0, 0), // couleur de l’ombre
            spreadRadius: 2, // étalement
            blurRadius: 5, // flou
            offset: Offset(3, 3), // décalage (x, y)
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Informations personnelles',
            onTap: () {},
          ),

          const Divider(height: 10),

          ProfileMenuItem(
            icon: Icons.child_care,
            title: 'Mes enfants',
            onTap: () {
              context.pushNamed(AppRoutes.childrenListName);
            },
          ),

          const Divider(height: 10),

          ProfileMenuItem(
            icon: Icons.inventory_2_outlined,
            title: 'Mes commandes',
            onTap: () {},
          ),

          const Divider(height: 10),

          ProfileMenuItem(
            icon: Icons.shopping_basket_outlined,
            title: 'Panier',
            onTap: () {},
          ),

          const Divider(height: 10),

          ProfileMenuItem(
            icon: Icons.favorite,
            iconColor: Colors.red,
            title: 'Favoris',
            onTap: () {},
          ),

          const Divider(height: 10),

          ProfileMenuItem(
            icon: Icons.settings_outlined,
            title: 'Paramètres',
            onTap: () {},
          ),
          const Divider(height: 10),

          ProfileMenuItem(
            icon: Icons.logout,
            title: 'Se déconnecter',
            onTap: () {},
          ),

          const Divider(height: 10),
        ],
      ),
    );
  }
}
