import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eveiloo_enfant/models/toy_model.dart';
import 'package:eveiloo_enfant/repository/toy_repository.dart';
import 'package:flutter/foundation.dart';

class ToySeeder {
  static final ToyRepository _toyRepository = ToyRepository();

  static final List<ToyModel> fakeToys = [
    ToyModel(
      id: '',
      nom: 'Blocs de Construction en Bois',
      description:
          'Jeu éducatif de 50 pièces pour développer la motricité fine et la créativité.',
      prix: 15000,
      imageUrl:
          'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=500',
      images: [
        'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=500',
      ],
      categorieId: 'construction',
      genre: 'garcon',
      ageRange: '4-6 ans',
      note: 4.8,
      nombreAvis: 12,
      tags: ['Éducatif', 'Bois', 'Créativité'],
      competences: ['Motricité fine', 'Logique'],
    ),
    ToyModel(
      id: '',
      nom: 'Puzzle Pédagogique Alphabets',
      description:
          'Puzzle coloré pour apprendre les lettres et les premiers mots en s\'amusant.',
      prix: 8500,
      imageUrl:
          'https://images.unsplash.com/photo-1618842676088-c4d48a6a7c9d?w=500',
      images: [
        'https://images.unsplash.com/photo-1618842676088-c4d48a6a7c9d?w=500',
      ],
      categorieId: 'puzzle',
      genre: 'fille',
      ageRange: '1-3 ans',
      note: 4.5,
      nombreAvis: 8,
      tags: ['Apprentissage', 'Lecture'],
      competences: ['Memoire', 'Langage'],
    ),
    ToyModel(
      id: '',
      nom: 'Kit de Peinture & Dessin',
      description:
          'Mallette d\'artiste complète avec aquarelles, pinceaux et crayons de couleur non toxiques.',
      prix: 12000,
      imageUrl:
          'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=500',
      images: [
        'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=500',
      ],
      categorieId: 'art',
      genre: 'fille',
      ageRange: '4-6 ans',
      note: 4.9,
      nombreAvis: 20,
      tags: ['Art', 'Couleurs'],
      competences: ['Créativité', 'Expression'],
    ),
    ToyModel(
      id: '',
      nom: 'Xylophone Éducatif',
      description:
          'Instrument de musique en bois à 8 lames métalliques colorées pour l\'éveil musical.',
      prix: 9500,
      imageUrl:
          'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=500',
      images: [
        'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=500',
      ],
      categorieId: 'musique',
      genre: 'garcon',
      ageRange: '1-3 ans',
      note: 4.2,
      nombreAvis: 5,
      tags: ['Musique', 'Eveil'],
      competences: ['Ouïe', 'Coordination'],
    ),
  ];

  /// Méthode d'injection des données dans Firestore
  static Future<void> seedDatabase() async {
    for (final toy in fakeToys) {
      try {
        await _toyRepository.addToy(toy);
        debugPrint('Jouet ajouté avec succès : ${toy.nom}');
      } catch (e) {
        debugPrint('Erreur lors de l\'ajout de ${toy.nom} : $e');
      }
    }
  }
}
