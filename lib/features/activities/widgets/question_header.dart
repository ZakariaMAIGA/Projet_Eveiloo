import 'package:flutter/material.dart';

class QuestionHeader extends StatelessWidget {
  final int current;
  final int total;
  final String title;
  final VoidCallback? onClose;

  const QuestionHeader({
    super.key,
    required this.current,
    required this.total,
    this.title = '',
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.close, color: Color(0xFF29258F), size: 26),
            ),
            if (title.isNotEmpty) ...[
              const SizedBox(width: 28),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF29258F),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 28),
            ],
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
        value: total == 0 ? 0 : current / total,
        minHeight: 14,
        backgroundColor: Colors.grey.shade300,
        valueColor: const AlwaysStoppedAnimation(Color(0xFF2D8DD5)),
      ),
    );
  }
}