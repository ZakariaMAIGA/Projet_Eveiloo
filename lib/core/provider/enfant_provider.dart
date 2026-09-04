import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/enfant.dart';
import '../../repository/enfant_repository.dart';
import 'auth_provider.dart';

final enfantRepositoryProvider = Provider<EnfantRepository>((ref) {
  return EnfantRepository();
});

/// Enfants de l'utilisateur connecte, derives automatiquement de son id
/// (aucun besoin de passer le parentId manuellement dans les widgets).
final mesEnfantsProvider = StreamProvider.autoDispose<List<EnfantModel>>((ref) {
  final sessionId = ref.watch(sessionProvider).value;

  final utilisateur = ref.watch(utilisateurCourantProvider).value;
  if (utilisateur == null || sessionId == null) {
    return Stream.value(<EnfantModel>[]);
  }

  return ref
      .watch(enfantRepositoryProvider)
      .observerEnfants(utilisateur.utilisateurId);
});

/// Actions de mutation (creer/modifier/supprimer un enfant), avec un
/// AsyncValue<void> pour piloter loading/erreur dans l'UI.
class EnfantActions extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  EnfantRepository get _repository => ref.read(enfantRepositoryProvider);

  String? get _parentId =>
      ref.read(utilisateurCourantProvider).value?.utilisateurId;

  Future<void> creer(EnfantModel enfant) async {
    final parentId = _parentId;
    if (parentId == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.creer(parentId, enfant));
  }

  Future<void> mettreAJour(
    String enfantId,
    Map<String, dynamic> donnees,
  ) async {
    final parentId = _parentId;
    if (parentId == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.mettreAJour(parentId, enfantId, donnees),
    );
  }

  Future<void> supprimer(String enfantId) async {
    final parentId = _parentId;
    if (parentId == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.supprimer(parentId, enfantId),
    );
  }
}

final enfantActionsProvider = AsyncNotifierProvider<EnfantActions, void>(
  EnfantActions.new,
);
