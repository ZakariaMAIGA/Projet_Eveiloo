// features/auth/auth_gate.dart
import 'package:eveiloo_enfant/core/provider/auth_provider.dart';
import 'package:eveiloo_enfant/features/auth/login_page.dart';
import 'package:eveiloo_enfant/features/home/home_page.dart'; // ou ton widget “home” principal
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateChangesProvider);

    return authAsync.when(
      data: (user) {
        final isLoggedIn = user != null;

        if (isLoggedIn) {
          // Quand connecté, on affiche le “vrai” point d’entrée de l’app.
          // Ici, on utilise le routeur nommé pour tomber sur le shell parent.
          // Tu peux aussi retourner directement un HomePage() si tu préfères.
          return const HomePage();
        } else {
          // Quand déconnecté, on affiche la page de login.
          return const LoginPage();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text('Erreur de chargement: $err'))),
    );
  }
}
