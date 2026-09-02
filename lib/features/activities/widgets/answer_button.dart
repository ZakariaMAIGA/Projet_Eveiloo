import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String text;

  /// URL d'une image optionnelle affichée à gauche du texte.
  final String? imageUrl;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;

  const AnswerButton({
    super.key,
    required this.text,
    this.imageUrl,
    required this.onTap,
    this.isSelected = false,
    this.isCorrect = false,
    this.showResult = false,
  });

  bool get hasImage => imageUrl != null && imageUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    Color background = Colors.white;
    Color border = Colors.transparent;

    if (showResult) {
      if (isCorrect) {
        background = const Color(0xFFC8F7D4);
        border = const Color(0xFF20B24B);
      } else if (isSelected) {
        // Mauvaise réponse choisie : affichée en rouge en même temps que
        // la bonne réponse en vert.
        background = const Color(0xFFFFD9D9);
        border = const Color(0xFFD93025);
      }
    } else if (isSelected) {
      background = Colors.deepPurple.shade50;
      border = Colors.deepPurple;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 15),
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: border,
            // Bordure visible pour la bonne réponse (vert) ET pour la
            // mauvaise réponse choisie (rouge), en même temps.
            width: showResult && (isCorrect || isSelected) ? 1 : 0,
          ),
        ),
        child: Row(
          children: [
            // Vignette d'image de la réponse : affichée dès qu'une URL est
            // fournie, sinon le cadre coloré adapté à l'état.
            if (hasImage)
              _AnswerImageThumbnail(imageUrl: imageUrl!)
            else if (isSelected || showResult && isCorrect)
              Container(
                width: 64,
                height: 74,
                margin: const EdgeInsets.only(right: 14),
                color: showResult && isSelected && !isCorrect
                    ? const Color(0xFFFFD9D9)
                    : const Color(0xFFE9FFF0),
              ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF29258F),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (showResult && isCorrect)
              const Icon(Icons.check_circle, color: Color(0xFF18A447), size: 28),
            if (showResult && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: Colors.red),
          ],
        ),
      ),
    );
  }
}

/// Vignette de l'image d'une réponse, chargée depuis une URL distante.
class _AnswerImageThumbnail extends StatelessWidget {
  final String imageUrl;

  const _AnswerImageThumbnail({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 74,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFDDF4FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl.trim(),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const ColoredBox(
              color: Color(0xFFDDF4FB),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
          errorBuilder: (_, error, stackTrace) => const ColoredBox(
            color: Color(0xFFDDF4FB),
            child: Icon(
              Icons.broken_image_outlined,
              color: Color(0xFF2D8DD5),
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}