import 'package:eveiloo_enfant/core/provider/auth_provider.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// AuthGate gère la direction initiale au lancement :
/// - Non connecté -> SplashPage (qui gère Splash > Onboarding/Overview > Login)
/// - Connecté (Admin) -> Dashboard Admin (/admin)
/// - Connecté (Parent/Enfant) -> HomePage (AppRoutes.homeName)
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Écoute l'état de connexion Firebase
    final authAsync = ref.watch(authStateChangesProvider);

    return authAsync.when(
      data: (user) {
        // Si l'utilisateur n'est pas connecté -> Direction le Splash
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.goNamed(AppRoutes.splashName);
            }
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Si connecté, on écoute le profil utilisateur Firestore
        final utilisateurAsync = ref.watch(utilisateurCourantProvider);

        return utilisateurAsync.when(
          data: (utilisateur) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;

              // Vérification du rôle via le provider dédié
              final estAdmin = ref.read(estAdminProvider);

              if (estAdmin) {
                // Redirection vers le Dashboard Admin
                context.go('/admin');
              } else {
                // Redirection vers l'accueil principal
                context.goNamed(AppRoutes.homeName);
              }
            });

            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (err, stack) => Scaffold(
            body: Center(
              child: Text('Erreur lors de la récupération du profil : $err'),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Erreur d\'authentification : $err')),
      ),
    );
  }
}
