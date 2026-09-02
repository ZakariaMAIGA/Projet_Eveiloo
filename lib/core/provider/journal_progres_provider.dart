import 'package:eveiloo_enfant/models/journal_progres_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repository/journal_progres_repository.dart';

final journalProgresRepositoryProvider = Provider<JournalProgresRepository>((
  ref,
) {
  return JournalProgresRepository();
});
final journalProgresEntreesEnfantProvider =
    StreamProvider.family<List<JournalProgresModel>, String>((ref, enfantId) {
      return ref
          .watch(journalProgresRepositoryProvider)
          .observerToutesActivites(enfantId);
    });
