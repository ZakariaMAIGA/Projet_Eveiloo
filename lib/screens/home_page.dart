import 'package:eveiloo_enfant/core/services/auth_service.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final utilisateur = authService.utilisateurFirebase;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Éveiloo'),
        actions: [
          IconButton(
            tooltip: 'Déconnexion',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.deconnexion();

              if (!context.mounted) return;

              context.goNamed(AppRoutes.loginName);
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          utilisateur == null
              ? 'Aucun utilisateur connecté'
              : 'Bonjour ${utilisateur.displayName ?? utilisateur.email}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
