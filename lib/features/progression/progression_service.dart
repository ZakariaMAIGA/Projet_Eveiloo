import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/progression_model.dart';

class ProgressionService {

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final String collection = "progressions";

  Future<void> saveProgression(
      ProgressionModel progression) async {

    await firestore
        .collection(collection)
        .doc(progression.progressionId)
        .set(progression.toMap());
  }

  Future<List<ProgressionModel>>
      getChildProgressions(String childId) async {

    final snapshot = await firestore
        .collection(collection)
        .where("childId", isEqualTo: childId)
        .get();

    return snapshot.docs
        .map((e) => ProgressionModel.fromMap(e.data()))
        .toList();
  }

  Future<void> deleteProgression(
      String progressionId) async {

    await firestore
        .collection(collection)
        .doc(progressionId)
        .delete();
  }

}