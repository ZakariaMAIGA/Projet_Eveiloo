import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/activity_model.dart';
import '../activity_service.dart';

/// Service

final activityServiceProvider = Provider<ActivityService>((ref) {
  return ActivityService();
});

/// Toutes les activités

final activitiesProvider =
    StreamProvider<List<ActivityModel>>((ref) {
  return ref.read(activityServiceProvider).getActivities();
});

/// Une activité

final activityProvider =
    FutureProvider.family<ActivityModel?, String>((ref, activityId) {
  return ref
      .read(activityServiceProvider)
      .getActivity(activityId);
});