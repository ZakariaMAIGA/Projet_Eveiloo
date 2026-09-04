import 'package:flutter/material.dart';

import '../../../models/activity_model.dart';

class ActivityResultPage extends StatelessWidget {
  final ActivityModel activity;
  final int score;
  final int totalQuestions;

  const ActivityResultPage({
    super.key,
    required this.activity,
    required this.score,
    required this.totalQuestions,
  });

  double get percentage {
    if (totalQuestions == 0) return 0;
    return (score / totalQuestions) * 100;
  }

  int get stars {
    if (percentage >= 90) return 3;
    if (percentage >= 60) return 2;
    if (percentage >= 40) return 1;
    return 0;
  }

  String get message {
    if (percentage >= 90) {
      return "Excellent travail !";
    }

    if (percentage >= 60) {
      return "Très bien !";
    }

    if (percentage >= 40) {
      return "Continue tes efforts !";
    }

    return "Réessaie encore.";
  }

  @override
  Widget build(BuildContext context) {
    final completedProgress = totalQuestions == 0
        ? 0.0
        : (score / totalQuestions).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Bravo !',
                      style: TextStyle(
                        color: Color(0xFF2D8DD5),
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Tu as terminé cette activité',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF29258F),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const _ResultIllustration(),
                    _ResultSummary(
                      score: score,
                      totalQuestions: totalQuestions,
                      points: score * activity.rewardPoints,
                    ),
                    const SizedBox(height: 28),
                    _ProgressSummary(
                      score: score,
                      totalQuestions: totalQuestions,
                      progress: completedProgress,
                    ),
                    const SizedBox(height: 54),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D8DD5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Continuer',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const _ResultNavigationBar(),
          ],
        ),
      ),
    );
  }
}

class _ResultIllustration extends StatelessWidget {
  const _ResultIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 265,
      child: ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 0.78,
          child: Image.asset(
            'assets/images/logo_eveiloo.png',
            width: 270,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _ResultSummary extends StatelessWidget {
  const _ResultSummary({
    required this.score,
    required this.totalQuestions,
    required this.points,
  });

  final int score;
  final int totalQuestions;
  final int points;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFDDF4FB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ResultValue(
              label: 'Score',
              value: '$score/$totalQuestions',
            ),
          ),
          Container(width: 1, height: 62, color: Colors.black38),
          Expanded(
            child: _ResultValue(
              label: 'Point gagnés',
              value: '+$points pts',
              icon: Icons.star,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultValue extends StatelessWidget {
  const _ResultValue({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF29258F),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              const Icon(Icons.star, color: Color(0xFFFFD600), size: 30),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF29258F),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary({
    required this.score,
    required this.totalQuestions,
    required this.progress,
  });

  final int score;
  final int totalQuestions;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(19, 25, 9, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFDDF4FB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progression de l’activité',
            style: TextStyle(
              color: Color(0xFF29258F),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$score/$totalQuestions histoires lues',
            style: const TextStyle(
              color: Color(0xFF29258F),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 700),
              builder: (_, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 15,
                backgroundColor: const Color(0xFFD0D0D0),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF2D8DD5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

