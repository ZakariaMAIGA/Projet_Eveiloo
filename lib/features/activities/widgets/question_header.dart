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
      children: [
        Row(
          children: [
            const Icon(Icons.close, color: Color(0xFF29258F), size: 42),
            const Spacer(),
            CircleAvatar(radius: 16, backgroundColor: const Color(0xFF8DDBFF), child: Text('$current/$total', style: const TextStyle(color: Color(0xFF29258F), fontSize: 11, fontWeight: FontWeight.w800))),
          ],
        ),
        const SizedBox(height: 14),
        progressBar(),
      ],
    );
  }

  Widget progressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: LinearProgressIndicator(
        value: current / total,
        minHeight: 14,
        backgroundColor: Colors.grey.shade300,
        valueColor: const AlwaysStoppedAnimation(Color(0xFF2D8DD5)),
      ),
    );
  }
}