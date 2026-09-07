import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/activities/activity_service.dart';
import '../../../models/Commande.dart';
import '../../../models/utilisateur.dart';
import '../../../repository/commande_repository.dart';
import '../../../repository/toy_repository.dart';
import '../../../repository/utilisateurRepository.dart';

final _utilisateurRepositoryProvider = Provider<UtilisateurRepository>((ref) {
  return UtilisateurRepository();
});

final _commandeRepositoryProvider = Provider<CommandeRepository>((ref) {
  return CommandeRepository();
});

final _toyRepositoryProvider = Provider<ToyRepository>((ref) {
  return ToyRepository();
});

final _activityServiceProvider = Provider<ActivityService>((ref) {
  return ActivityService();
});

/// Nombre total d'utilisateurs.
final utilisateursCountProvider = FutureProvider.autoDispose<int>((ref) {
  return ref.watch(_utilisateurRepositoryProvider).compterUtilisateurs();
});

/// Nombre de commandes "en cours" (ni livrées, ni annulées).
final commandesActuellesCountProvider = FutureProvider.autoDispose<int>((ref) {
  return ref.watch(_commandeRepositoryProvider).compterCommandesActuelles();
});

/// Nombre total de jouets au catalogue.
final jouetsCountProvider = FutureProvider.autoDispose<int>((ref) {
  return ref.watch(_toyRepositoryProvider).compterJouets();
});

/// Nombre total d'activités au catalogue.
final activitesCountProvider = FutureProvider.autoDispose<int>((ref) {
  return ref.watch(_activityServiceProvider).compterActivites();
});

/// Les 3 derniers utilisateurs inscrits.
final derniersUtilisateursProvider =
    StreamProvider.autoDispose<List<UtilisateurModel>>((ref) {
      return ref
          .watch(_utilisateurRepositoryProvider)
          .observerDerniersUtilisateurs(limite: 3);
    });

/// Les 3 dernières commandes passées, tous utilisateurs confondus.
final dernieresCommandesProvider = StreamProvider.autoDispose<List<Commande>>((
  ref,
) {
  return ref
      .watch(_commandeRepositoryProvider)
      .observerDernieresCommandes(limite: 3);
});
