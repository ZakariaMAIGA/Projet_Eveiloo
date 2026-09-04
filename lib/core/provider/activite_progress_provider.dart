import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/activite_progress_model.dart';
import '../../repository/activite_progress_repository.dart';

final activiteProgressRepositoryProvider = Provider<ActiviteProgressRepository>(
  (ref) {
    return ActiviteProgressRepository();
  },
);

/// Progression d'un enfant sur toutes les activités, indexée par activityId.
final activiteProgressMapProvider =
    StreamProvider.family<Map<String, ActiviteProgressModel>, String>((
      ref,
      enfantId,
    ) {
      return ref
          .watch(activiteProgressRepositoryProvider)
          .observerProgressions(enfantId);
    });
