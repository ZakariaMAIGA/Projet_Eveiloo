import 'package:flutter_riverpod/legacy.dart';

/// Enfant actuellement "actif" dans le shell enfant.
/// Défini au moment d'entrer dans l'espace enfant depuis MesEnfantsPage.
final enfantSelectionneProvider = StateProvider<String?>((ref) => null);
