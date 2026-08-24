import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final ValueChanged<int>? onQuantiteChanged;
  final VoidCallback? onSupprimer;

  const CartItemCard({
    super.key,
    required this.item,
    this.onQuantiteChanged,
    this.onSupprimer,
  });

  String _formaterPrix(double prix) {
    final chaine = prix.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < chaine.length; i++) {
      final positionDepuisFin = chaine.length - i;
      if (i != 0 && positionDepuisFin % 3 == 0) buffer.write(' ');
      buffer.write(chaine[i]);
    }
    return '${buffer.toString()} F';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.urlImage,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 64,
                height: 64,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image_not_supported_outlined,
                    color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nom,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formaterPrix(item.prixUnitaire),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onLongPress: onSupprimer,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                '${item.quantite} X',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
