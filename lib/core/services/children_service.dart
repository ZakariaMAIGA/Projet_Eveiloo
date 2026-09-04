import 'package:eveiloo_enfant/core/services/auth_service.dart';
import 'package:eveiloo_enfant/models/enfant.dart';
import 'package:eveiloo_enfant/repository/enfant_repository.dart';

class EnfantService {
  final AuthService _authService;
  final EnfantRepository _enfantRepository;

  EnfantService({
    AuthService? authService,
    EnfantRepository? enfantRepository,
  })  : _authService = authService ?? AuthService(),
        _enfantRepository =
            enfantRepository ?? EnfantRepository();

  String get _parentId {
    final utilisateur = _authService.utilisateurFirebase;

    if (utilisateur == null) {
      throw Exception(
        'Aucun utilisateur connecté.',
      );
    }

    return utilisateur.uid;
  }

  Future<String> ajouterEnfant(
    EnfantModel enfant,
  ) async {
    try {
      return await _enfantRepository.creer(
        _parentId,
        enfant,
      );
    } catch (e) {
      throw Exception(
        'Erreur lors de l\'ajout de l\'enfant : $e',
      );
    }
  }

  Stream<List<EnfantModel>> observerEnfants() {
    try {
      return _enfantRepository.observerEnfants(
        _parentId,
      );
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération des enfants : $e',
      );
    }
  }

  Future<EnfantModel?> getEnfantById(
    String enfantId,
  ) async {
    try {
      return await _enfantRepository.obtenirParId(
        _parentId,
        enfantId,
      );
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération de l\'enfant : $e',
      );
    }
  }

  Future<void> modifierEnfant(
    EnfantModel enfant,
  ) async {
    try {
      await _enfantRepository.mettreAJour(
        _parentId,
        enfant.enfantId,
        enfant.toMap(),
      );
    } catch (e) {
      throw Exception(
        'Erreur lors de la modification de l\'enfant : $e',
      );
    }
  }

  Future<void> supprimerEnfant(
    String enfantId,
  ) async {
    try {
      await _enfantRepository.supprimer(
        _parentId,
        enfantId,
      );
    } catch (e) {
      throw Exception(
        'Erreur lors de la suppression de l\'enfant : $e',
      );
    }
  }
}