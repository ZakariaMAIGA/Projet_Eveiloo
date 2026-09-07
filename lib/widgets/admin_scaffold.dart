import 'package:eveiloo_enfant/core/constants/admin_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'admin_drawer.dart';

/// Scaffold commun à toutes les pages admin en mobile :
/// - AppBar blanche avec bouton hamburger (auto, via `drawer:`)
/// - Le menu (AdminDrawer) sort en overlay par-dessus la page
/// - `actions` permet d'ajouter un bouton "+" pour les pages Jouets /
///   Activités / Tutoriels (ex: ouvrir la page d'ajout).
class AdminScaffold extends StatelessWidget {
  const AdminScaffold({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  final String title;
  final String currentRoute;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AdminColors.textDark,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        actions: actions,
      ),
      drawer: AdminDrawer(
        currentRoute: currentRoute,
        onNavigate: (route) {
          // Adapte cet appel à ton routeur si tu n'utilises pas GoRouter.
          context.go(route);
        },
      ),
      floatingActionButton: floatingActionButton,
      body: SafeArea(child: body),
    );
  }
}
