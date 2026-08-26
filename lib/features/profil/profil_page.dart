import 'package:eveiloo_enfant/core/services/auth_service.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
 Widget build(BuildContext context) {
    final authService = AuthService();
    final utilisateur = authService.utilisateurFirebase;

    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 12),
            Text(
              utilisateur?.displayName ?? 'Parent',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(utilisateur?.email ?? ''),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                await authService.deconnexion();

                if (!context.mounted) return;

                context.goNamed(AppRoutes.loginName);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
