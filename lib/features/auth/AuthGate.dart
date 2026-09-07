// features/auth/auth_gate.dart
import 'package:eveiloo_enfant/core/provider/auth_provider.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// AuthGate ne doit JAMAIS retourner directement HomePage()/LoginPage()
/// comme widget : ça les affiche à la location '/' (racine), en dehors
/// du StatefulShellRoute.indexedStack qui fournit la barre de tabs.
///
/// Il doit toujours NAVIGUER (context.goNamed) vers la vraie route, pour
/// que le contenu passe par le shell parent et affiche les tabs.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateChangesProvider);

    return authAsync.when(
      data: (user) {
        final destination = user != null
            ? AppRoutes.homeName
            : AppRoutes.loginName;

        // On ne peut pas naviguer pendant build() ; on le fait juste après,
        // une seule fois que ce frame est posé.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          context.goNamed(destination);
        });

        // Écran transitoire affiché le temps que la navigation se fasse.
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text('Erreur de chargement: $err'))),
    );
  }
}
