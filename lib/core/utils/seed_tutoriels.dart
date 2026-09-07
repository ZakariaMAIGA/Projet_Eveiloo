import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eveiloo_enfant/models/TutorielModel.dart';
import 'package:eveiloo_enfant/repository/tutoriel_repository.dart';
import 'package:flutter/foundation.dart';

class TutorielSeeder {
  static final TutorielRepository _tutorielRepository = TutorielRepository();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Récupère des IDs de jouets existants pour les associer aux tutoriels
  static Future<List<String>> _getExistingToyIds() async {
    final snapshot = await _firestore.collection('JOUETS').limit(5).get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  /// Méthode principale d'injection des tutoriels
  static Future<void> seedDatabase() async {
    // On récupère quelques IDs de jouets réels dans Firestore
    final toyIds = await _getExistingToyIds();

    final List<TutorielModel> fakeTutoriels = [
      TutorielModel(
        tutorielId: '',
        titre: 'Créer une tour de blocs géante',
        description:
            'Apprenez à votre enfant à empiler et équilibrer les formes géométriques pour développer sa coordination.',
        urlVideo:
            'https://iizrtcjighmropnczkgw.supabase.co/storage/v1/object/public/tutoriels-videos/WhatsApp%20Video%202026-09-03%20at%2007.40.04.mp4',
        urlImage:
            'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=500',
        ageMin: 3,
        ageMax: 6,
        categorie: 'Construction',
        dateCreation: DateTime.now(),
        materielIds: toyIds.isNotEmpty ? [toyIds.first] : [],
      ),
      TutorielModel(
        tutorielId: '',
        titre: 'Atelier Peinture avec les doigts',
        description:
            'Découvrez des techniques simples pour stimuler l\'expression artistique sans danger.',
        urlVideo:
            'https://iizrtcjighmropnczkgw.supabase.co/storage/v1/object/public/tutoriels-videos/7955b013aa36b252d0593c64f48149df.mp4',
        urlImage:
            'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=500',
        ageMin: 2,
        ageMax: 5,
        categorie: 'Art & Créativité',
        dateCreation: DateTime.now().subtract(const Duration(days: 1)),
        materielIds: toyIds.length > 1 ? [toyIds[1]] : [],
      ),
      TutorielModel(
        tutorielId: '',
        titre: 'Éveil Musical : Rythme et Lames',
        description:
            'Exercices ludiques pour reconnaître les sons et travailler le rythme avec un instrument.',
        urlVideo:
            'https://iizrtcjighmropnczkgw.supabase.co/storage/v1/object/public/tutoriels-videos/1d997840daecdf7ff8924004539aad30_720w.mp4',
        urlImage:
            'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=500',
        ageMin: 1,
        ageMax: 4,
        categorie: 'Musique',
        dateCreation: DateTime.now().subtract(const Duration(days: 2)),
        materielIds: toyIds, // Associe tous les jouets trouvés
      ),
    ];

    for (final tutoriel in fakeTutoriels) {
      try {
        final id = await _tutorielRepository.ajouter(tutoriel);
        debugPrint('Tutoriel ajouté avec succès ID : $id');
      } catch (e) {
        debugPrint(
          'Erreur lors de l\'ajout du tutoriel ${tutoriel.titre} : $e',
        );
      }
    }
  }
}
