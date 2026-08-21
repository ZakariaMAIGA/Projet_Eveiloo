class CartItemModel {
  final String toyId;
  final String toyName;
  final String toyImage;
  final double price;
  final int quantity;

  const CartItemModel({
    required this.toyId,
    required this.toyName,
    required this.toyImage,
    required this.price,
    required this.quantity,
  });

  // Getter calculé
  double get total => price * quantity;

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      toyId: map['toyId'] ?? '',
      toyName: map['toyName'] ?? '',
      toyImage: map['toyImage'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
    );
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel.fromMap(json);
  }

  Map<String, dynamic> toMap() {
    return {
      'toyId': toyId,
      'toyName': toyName,
      'toyImage': toyImage,
      'price': price,
      'quantity': quantity,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  CartItemModel copyWith({
    String? toyId,
    String? toyName,
    String? toyImage,
    double? price,
    int? quantity,
  }) {
    return CartItemModel(
      toyId: toyId ?? this.toyId,
      toyName: toyName ?? this.toyName,
      toyImage: toyImage ?? this.toyImage,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'CartItemModel('
        'toyId: $toyId, '
        'toyName: $toyName, '
        'price: $price, '
        'quantity: $quantity, '
        'total: $total'
        ')';
  }
}