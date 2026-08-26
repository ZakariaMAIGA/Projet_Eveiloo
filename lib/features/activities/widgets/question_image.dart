import 'package:flutter/material.dart';

class QuestionImage extends StatelessWidget {
  final String imageUrl;

  const QuestionImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          imageUrl,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, error, stackTrace) => Container(
            height: 220,
            width: double.infinity,
            color: const Color(0xFFDDF4FB),
            alignment: Alignment.center,
            child: const Icon(
              Icons.broken_image_outlined,
              color: Color(0xFF2D8DD5),
              size: 58,
            ),
          ),
        ),
      ),
    );
  }
}