import 'package:flutter/material.dart';

import '../../../models/journal_progres_model.dart';

class RecentActivityTile extends StatelessWidget {
  const RecentActivityTile({
    super.key,
    required this.entree,
    required this.prenomEnfant,
  });

  final JournalProgresModel entree;
  final String prenomEnfant;

  @override
  Widget build(BuildContext context) {
    final estTutoriel = entree.typeElement == 'tutoriel';
    final verbe = estTutoriel ? 'a terminé' : 'a réussi';
    final complement = estTutoriel ? 'un tutoriel' : 'une activité';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: (estTutoriel ? Colors.blue : Colors.orange)
            .withOpacity(0.12),
        child: Icon(
          estTutoriel
              ? Icons.play_circle_fill_rounded
              : Icons.emoji_events_rounded,
          color: estTutoriel ? Colors.blue : Colors.orange,
        ),
      ),
      title: Text(
        entree.titre,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        '$prenomEnfant $verbe $complement',
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
    );
  }
}
