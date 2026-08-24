import 'package:flutter/material.dart';

class QuestionHeader extends StatelessWidget {
  final int current;
  final int total;

  const QuestionHeader({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Question $current / $total",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 15),
        LinearProgressIndicator(
          value: current / total,
          minHeight: 10,
          borderRadius: BorderRadius.circular(15),
        ),
      ],
    );
  }
}