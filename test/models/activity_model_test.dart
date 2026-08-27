import 'package:flutter_test/flutter_test.dart';
import 'package:eveiloo_enfant/models/activity_model.dart';

void main() {
  group('ActivityModel — statuts et sérialisation', () {
    test('round-trip toMap/fromMap conserve les dates de début et de fin', () {
      final now = DateTime(2024, 5, 1, 10, 30);
      final activity = ActivityModel(
        activityId: 'act-1',
        title: 'Compter les animaux',
        description: 'Une activité de comptage',
        minAge: 3,
        maxAge: 5,
        activityType: 'quiz',
        competenceCategory: 'Mathématiques',
        rewardPoints: 10,
        successThreshold: 70,
        duration: 120,
        progress: 45.0,
        imageUrl: 'https://example.com/img.png',
        objective: 'Apprendre à compter',
        createdAt: now,
        startedAt: now.add(const Duration(minutes: 1)),
        completedAt: now.add(const Duration(minutes: 9)),
      );

      final restored = ActivityModel.fromMap(activity.toMap());

      expect(restored, equals(activity));
    });

    test('le cycle de vie suit : à faire → en cours → terminée', () {
      var activity = ActivityModel.empty();
      expect(activity.status, ActivityStatus.aFaire);
      expect(activity.isStarted, isFalse);
      expect(activity.isCompleted, isFalse);

      // L'enfant sélectionne l'activité dans l'onglet « Toutes »
      activity = activity.copyWith(startedAt: DateTime.now());
      expect(activity.status, ActivityStatus.enCours);
      expect(activity.isStarted, isTrue);
      expect(activity.isCompleted, isFalse);

      // L'enfant termine la session de jeu
      activity = activity.copyWith(completedAt: DateTime.now());
      expect(activity.status, ActivityStatus.terminee);
      expect(activity.isCompleted, isTrue);
    });

    test('une activité terminée reste terminée même si re-commencée', () {
      final completed = ActivityModel.empty().copyWith(
        startedAt: DateTime(2024, 1, 1),
        completedAt: DateTime(2024, 1, 2),
      );

      expect(completed.status, ActivityStatus.terminee);
      expect(ActivityStatus.terminee.label, 'Terminée');
      expect(ActivityStatus.enCours.label, 'En cours');
    });

    test('fromMap tolère un document ancien sans startedAt/completedAt', () {
      final legacy = ActivityModel.fromMap({
        'activityId': 'old-1',
        'title': 'Ancienne activité',
        'description': '',
        'minAge': 2,
        'maxAge': 4,
        'activityType': 'quiz',
        'competenceCategory': 'Lecture',
        'rewardPoints': 5,
        'successThreshold': 60,
        'duration': 60,
        'progress': 0,
        'createdAt': DateTime(2023, 3, 1).toIso8601String(),
      });

      expect(legacy.startedAt, isNull);
      expect(legacy.completedAt, isNull);
      expect(legacy.status, ActivityStatus.aFaire);
    });
  });
}
