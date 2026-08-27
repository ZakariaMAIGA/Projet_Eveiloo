import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;

  const AnswerButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
    this.isCorrect = false,
    this.showResult = false,
  });

  @override
  Widget build(BuildContext context) {
    Color background = Colors.white;
    Color border = Colors.transparent;

    if (showResult) {
      if (isCorrect) {
        background = const Color(0xFFC8F7D4);
        border = const Color(0xFF20B24B);
      } else if (isSelected) {
        background = const Color(0xFFFFE7E7);
        border = Colors.red;
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
        height: 92,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: border,
            width: showResult && isCorrect ? 1 : 0,
          ),
        ),
        child: Row(
          children: [
            if (isSelected || showResult && isCorrect)
              Container(
                width: 72,
                height: 90,
                margin: const EdgeInsets.only(right: 14),
                color: const Color(0xFFE9FFF0),
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
              const Icon(Icons.check_circle, color: Color(0xFF18A447), size: 40),
            if (showResult && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: Colors.red),
          ],
        ),
      ),
    );
  }
}