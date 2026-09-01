import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/TutorielModel.dart';
import '../../models/toy_model.dart';
import '../../repository/tutoriel_repository.dart';
import 'toy_repository.dart';

final tutorielRepositoryProvider = Provider<TutorielRepository>((ref) {
  return TutorielRepository();
});

final tutorielsProvider = StreamProvider<List<TutorielModel>>((ref) {
  return ref.watch(tutorielRepositoryProvider).observerTutoriels();
});

/// Un seul tutoriel par id (utile pour Favoris, notifications, deep links).
final tutorielProvider = FutureProvider.family<TutorielModel?, String>((
  ref,
  tutorielId,
) {
  return ref.watch(tutorielRepositoryProvider).getTutoriel(tutorielId);
});

final jouetsTutorielProvider =
    FutureProvider.family<List<ToyModel>, List<String>>((ref, ids) async {
      return ref.watch(toyRepositoryProvider).getJouetsParIds(ids);
    });
