import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/activity_model.dart';

class ActivityRepository {
  ActivityRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _activities =>
      _firestore.collection('activities');

  Future<void> create(ActivityModel activity) {
    return _activities.doc(activity.activityId).set(activity.toMap());
  }

  Future<ActivityModel?> getById(String activityId) async {
    final document = await _activities.doc(activityId).get();
    if (!document.exists || document.data() == null) return null;

    return ActivityModel.fromMap({
      ...document.data()!,
      'activityId': document.data()!['activityId'] ?? document.id,
    });
  }

  Stream<ActivityModel?> watchById(String activityId) {
    return _activities.doc(activityId).snapshots().map((document) {
      if (!document.exists || document.data() == null) return null;

      return ActivityModel.fromMap({
        ...document.data()!,
        'activityId': document.data()!['activityId'] ?? document.id,
      });
    });
  }

  Stream<List<ActivityModel>> watchAll() {
    return _activities
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (document) => ActivityModel.fromMap({
                  ...document.data(),
                  'activityId': document.data()['activityId'] ?? document.id,
                }),
              )
              .toList(),
        );
  }

  Future<void> update(ActivityModel activity) {
    return _activities.doc(activity.activityId).update(activity.toMap());
  }

  Future<void> delete(String activityId) {
    return _activities.doc(activityId).delete();
  }
}
