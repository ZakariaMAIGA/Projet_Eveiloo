import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/TutorielModel.dart';

class TutorielRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collection = 'tutoriels';

  Stream<List<TutorielModel>> observerTutoriels() {
    return _firestore
        .collection(collection)
        .orderBy('dateCreation', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TutorielModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<TutorielModel?> getTutoriel(String tutorielId) async {
    final doc = await _firestore.collection(collection).doc(tutorielId).get();
    if (!doc.exists) return null;
    return TutorielModel.fromFirestore(doc);
  }
}
