import 'package:eveiloo_enfant/models/toy_model.dart';
import 'package:eveiloo_enfant/repository/toy_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider du dépôt des jouets
final toyRepositoryProvider = Provider<ToyRepository>((ref) {
  return ToyRepository();
});

// FutureProvider.family pour charger la liste des jouets du tutoriel via leurs IDs
final jouetsTutorielProvider =
    FutureProvider.family<List<ToyModel>, List<String>>((ref, ids) async {
      return ref.watch(toyRepositoryProvider).getJouetsParIds(ids);
    });

 
