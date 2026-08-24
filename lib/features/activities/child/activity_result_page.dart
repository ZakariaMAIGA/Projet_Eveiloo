import 'package:flutter/material.dart';

import '../../../models/activity_model.dart';
import 'activity_play_page.dart';

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
    final maxScore = activity.rewardPoints * totalQuestions;

    if (maxScore == 0) return 0;

    return (score / maxScore) * 100;
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),

          child: Column(
            children: [

              const SizedBox(height: 20),

              const Text('Bravo !', style: TextStyle(color: Color(0xFF2D8DD5), fontSize: 32, fontWeight: FontWeight.w800)),

              const SizedBox(height: 20),

              Text(
                'Tu as terminé cette activité',
                style: const TextStyle(
                  color: Color(0xFF29258F),
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Text(
                'Score : $score/$totalQuestions   +${score * activity.rewardPoints} pts',
                style: const TextStyle(color: Color(0xFF29258F), fontSize: 21, fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 35),

              Card(
                color: const Color(0xFFDDF4FB),
                elevation: 5,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(25),

                  child: Column(

                    children: [

                      Text(
                        "$score pts",
                        style: const TextStyle(
                          color: Color(0xFF29258F),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "${percentage.toStringAsFixed(0)} %",
                        style: const TextStyle(
                          color: Color(0xFF29258F),
                          fontSize: 22,
                        ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: List.generate(
                          3,
                          (index) {

                            return Icon(

                              index < stars
                                  ? Icons.star
                                  : Icons.star_border,

                              color: Colors.amber,

                              size: 45,

                            );

                          },
                        ),

                      )

                    ],

                  ),

                ),

              ),

              const Spacer(),

              SizedBox(

                width: double.infinity,

                height: 55,

                child: ElevatedButton.icon(

                  icon: const Icon(Icons.refresh),

                  label: const Text("Continuer"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D8DD5),
                    foregroundColor: Colors.white,
                  ),

                  onPressed: () {

                    Navigator.pushReplacement(

                      context,

                      MaterialPageRoute(

                        builder: (_) => ActivityPlayPage(

                          activity: activity,

                        ),

                      ),

                    );

                  },

                ),

              ),

              const SizedBox(height: 15),

              SizedBox(

                width: double.infinity,

                height: 55,

                child: OutlinedButton.icon(

                  icon: const Icon(Icons.home),

                  label: const Text("Retour"),

                  onPressed: () {

                    Navigator.popUntil(

                      context,

                      (route) => route.isFirst,

                    );

                  },

                ),

              ),

            ],

          ),

        ),

      ),

    );
  }

}