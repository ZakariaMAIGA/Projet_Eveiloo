class CommandeListeModel {
  final String toyId;
  final String toyName;
  final String toyImage;
  final double unitPrice;
  final int quantity;

  const CommandeListeModel({
    required this.toyId,
    required this.toyName,
    required this.toyImage,
    required this.unitPrice,
    required this.quantity,
  });

  double get totalPrice => unitPrice * quantity;

  factory CommandeListeModel.fromMap(Map<String, dynamic> map) {
    return CommandeListeModel(
      toyId: map['toyId'] ?? '',
      toyName: map['toyName'] ?? '',
      toyImage: map['toyImage'] ?? '',
      unitPrice: (map['unitPrice'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
    );
  }

  factory CommandeListeModel.fromJson(Map<String, dynamic> json) {
    return CommandeListeModel.fromMap(json);
  }

  Map<String, dynamic> toMap() {
    return {
      'toyId': toyId,
      'toyName': toyName,
      'toyImage': toyImage,
      'unitPrice': unitPrice,
      'quantity': quantity,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  CommandeListeModel copyWith({
    String? toyId,
    String? toyName,
    String? toyImage,
    double? unitPrice,
    int? quantity,
  }) {
    return CommandeListeModel(
      toyId: toyId ?? this.toyId,
      toyName: toyName ?? this.toyName,
      toyImage: toyImage ?? this.toyImage,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'CommandeListeModel('
        'toyId: $toyId, '
        'toyName: $toyName, '
        'unitPrice: $unitPrice, '
        'quantity: $quantity, '
        'totalPrice: $totalPrice'
        ')';
  }
}