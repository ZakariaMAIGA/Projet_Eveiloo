import 'package:cloud_firestore/cloud_firestore.dart';

/// Type d'élément mis en favori (jouet, tutoriel ou activité).
enum TypeFavori {
  jouet,
  tutoriel;

  static TypeFavori fromString(String? value) {
    switch (value) {
      case 'tutoriel':
        return TypeFavori.tutoriel;
      case 'jouet':
      default:
        return TypeFavori.jouet;
    }
  }

  String toValue() => name;
}

class Favoris {
  final String favoriId;
  final String enfantId;
  final String elementId;
  final TypeFavori type;
  final DateTime? dateAjout;

  const Favoris({
    required this.favoriId,
    required this.enfantId,
    required this.elementId,
    required this.type,
    this.dateAjout,
  });

  factory Favoris.fromMap(Map<String, dynamic> map, String id) {
    return Favoris(
      favoriId: id,
      enfantId: map['enfantId'] ?? '',
      elementId: map['elementId'] ?? '',
      type: TypeFavori.fromString(map['type'] as String?),
      dateAjout: (map['dateAjout'] as Timestamp?)?.toDate(),
    );
  }

  factory Favoris.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Favoris.fromMap(doc.data() ?? {}, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'enfantId': enfantId,
      'elementId': elementId,
      'type': type.toValue(),
      'dateAjout': dateAjout != null
          ? Timestamp.fromDate(dateAjout!)
          : FieldValue.serverTimestamp(),
    };
  }

  Favoris copyWith({
    String? favoriId,
    String? enfantId,
    String? elementId,
    TypeFavori? type,
    DateTime? dateAjout,
  }) {
    return Favoris(
      favoriId: favoriId ?? this.favoriId,
      enfantId: enfantId ?? this.enfantId,
      elementId: elementId ?? this.elementId,
      type: type ?? this.type,
      dateAjout: dateAjout ?? this.dateAjout,
    );
  }
}
