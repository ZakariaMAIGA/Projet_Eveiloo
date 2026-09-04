import 'package:eveiloo_enfant/models/utilisateur.dart';
import 'package:eveiloo_enfant/repository/utilisateurRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

// Ce fichier remplace utilisateur_service.dart / utilisateur_provider.dart
// generes precedemment : on garde ton AuthService + UtilisateurRepository
// tels quels, et on ajoute juste la couche Riverpod par-dessus.

final utilisateurRepositoryProvider = Provider<UtilisateurRepository>((ref) {
  return UtilisateurRepository();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    utilisateurRepository: ref.watch(utilisateurRepositoryProvider),
  );
});

/// Flux brut Firebase (utile pour le routing : connecte / pas connecte).
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Profil Firestore de l'utilisateur connecte, derive automatiquement
/// de authStateChanges (se recalcule a chaque connexion/deconnexion).
final utilisateurCourantProvider = StreamProvider<UtilisateurModel?>((ref) {
  final authService = ref.watch(authServiceProvider);
  final repository = ref.watch(utilisateurRepositoryProvider);

  return authService.authStateChanges.asyncExpand((firebaseUser) {
    if (firebaseUser == null) return Stream.value(null);
    return repository.observerParId(firebaseUser.uid);
  });
});

/// Raccourci pratique pour les ecrans/reglages qui doivent verifier le role.
final estAdminProvider = Provider<bool>((ref) {
  final utilisateur = ref.watch(utilisateurCourantProvider).value;
  return utilisateur?.role == RoleUtilisateur.admin;
});

/// Actions d'authentification (inscription, connexion, deconnexion...).
/// state expose un AsyncValue<void> pour piloter loading/erreur dans l'UI
/// (ex: ref.watch(authActionsProvider).isLoading dans un bouton).
// core/provider/auth_provider.dart (inchangé dans l’idée)
class AuthActions extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  AuthService get _service => ref.read(authServiceProvider);

  Future<void> inscription({
    required String nom,
    required String prenom,
    required String courriel,
    required String motDePasse,
    String? telephone,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _service.inscription(
        nom: nom,
        prenom: prenom,
        courriel: courriel,
        motDePasse: motDePasse,
        telephone: telephone,
      ),
    );
  }

  Future<void> connexion({
    required String courriel,
    required String motDePasse,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _service.connexion(courriel: courriel, motDePasse: motDePasse),
    );
  }

  Future<void> deconnexion() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.deconnexion());
  }

  Future<void> reinitialiserMotDePasse(String courriel) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _service.reinitialiserMotDePasse(courriel),
    );
  }
}

final authActionsProvider = AsyncNotifierProvider<AuthActions, void>(
  AuthActions.new,
);

final sessionProvider = StreamProvider<String?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges.map((user) {
    return user?.uid; // null si déconnecté, uid si connecté
  });
});
