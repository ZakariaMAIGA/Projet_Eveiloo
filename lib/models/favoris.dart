import 'package:cloud_firestore/cloud_firestore.dart';


class Favoris {
  final String id;
  final String enfantId;
  final String elementId  ;
  final String type;
  final DateTime dateAjout;

  Favoris({
    required this.id,
    required this.enfantId,
    required this.elementId,
    required this.type,
    required this.dateAjout,
  });

  factory Favoris.fromJson(Map<String, dynamic> json) {
    return Favoris(
      id: json['id'].toString(),
      enfantId: json['enfantId'].toString(),
      elementId: json['jouetId'].toString(),
      type: json['type'] as String,
      dateAjout: DateTime.parse(json['dateAjout'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enfantId': enfantId,
      'elementId': elementId,
      'type': type,
      'dateAjout': dateAjout.toIso8601String(),
    };
  }

  factory Favoris.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Favoris(
      id: doc.id,
      enfantId: data['enfantId'] as String,
      elementId: data['elementId'] as String,
      type: data['type'] as String,
      dateAjout: (data['dateAjout'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'enfantId': enfantId,
      'elementId': elementId,
      'type': type,
      'dateAjout': Timestamp.fromDate(dateAjout),
    };
  }
}