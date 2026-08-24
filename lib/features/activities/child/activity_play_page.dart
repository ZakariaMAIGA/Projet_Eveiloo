import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/activity_model.dart';
import '../../../models/proposition.dart';
import '../../../models/question_model.dart';
import '../providers/question_provider.dart';
import '../widgets/answer_button.dart';
import '../widgets/question_header.dart';
import 'activity_result_page.dart';

class ActivityPlayPage extends ConsumerStatefulWidget {
  final ActivityModel activity;

  const ActivityPlayPage({
    super.key,
    required this.activity,
  });

  @override
  ConsumerState<ActivityPlayPage> createState() => _ActivityPlayPageState();
}

class _ActivityPlayPageState extends ConsumerState<ActivityPlayPage> {
  int currentQuestion = 0;
  int score = 0;
  bool answered = false;
  String? selectedAnswer;
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void nextQuestion(List<QuestionModel> questions) {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        answered = false;
        selectedAnswer = null;
        textController.clear();
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ActivityResultPage(
            score: score,
            totalQuestions: questions.length,
            activity: widget.activity,
          ),
        ),
      );
    }
  }

  void checkAnswer(QuestionModel question, dynamic answer) {
    if (answered) return;

    bool correct = false;

    switch (question.type) {
      case QuestionType.multipleChoice:
        // For multiple choice, answer is a Proposition object
        correct = answer is Proposition && answer.id == question.correctAnswer;
        break;

      case QuestionType.numeric:
        final value = double.tryParse(answer.toString());
        if (value != null && question.correctNumericAnswer != null) {
          correct = (value - question.correctNumericAnswer!).abs() <= question.tolerance;
        }
        break;

      case QuestionType.text:
        if (question.caseSensitive) {
          correct = answer == question.freeTextAnswer;
        } else {
          correct = answer.toString().toLowerCase() == question.freeTextAnswer.toLowerCase();
        }
        break;
    }

    if (correct) {
      score += widget.activity.rewardPoints;
    }

    setState(() {
      answered = true;
      selectedAnswer = answer.toString();
    });
  }

  Widget buildQuestionWidget(QuestionModel question) {
    switch (question.type) {
      case QuestionType.multipleChoice:
        return buildQCM(question);
      case QuestionType.numeric:
        return buildNumeric(question);
      case QuestionType.text:
        return buildText(question);
    }
  }

  Widget buildQCM(QuestionModel question) {
    return ListView.builder(
      itemCount: question.options.length,
      itemBuilder: (context, index) {
        final proposition = question.options[index];

        return AnswerButton(
          text: proposition.texte,
          isSelected: selectedAnswer == proposition.texte,
          showResult: answered,
          isCorrect: proposition.id == question.correctAnswer,
          onTap: () {
            checkAnswer(
              question,
              proposition,
            );
          },
        );
      },
    );
  }

  Widget buildNumeric(QuestionModel question) {
    return Column(
      children: [
        TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          enabled: !answered,
          decoration: const InputDecoration(
            hintText: "Votre réponse",
          ),
        ),
        const SizedBox(height: 25),
        if (!answered)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  checkAnswer(
                    question,
                    textController.text.trim(),
                  );
                }
              },
              child: const Text("Valider"),
            ),
          )
      ],
    );
  }

  Widget buildText(QuestionModel question) {
    return Column(
      children: [
        TextField(
          controller: textController,
          keyboardType: TextInputType.text,
          enabled: !answered,
          decoration: const InputDecoration(
            hintText: "Votre réponse textuelle",
          ),
        ),
        const SizedBox(height: 25),
        if (!answered)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  checkAnswer(
                    question,
                    textController.text.trim(),
                  );
                }
              },
              child: const Text("Valider"),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsProvider(widget.activity.activityId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.activity.title),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF29258F),
      ),
      body: questionsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, s) => Center(
          child: Text(e.toString()),
        ),
        data: (questions) {
          if (questions.isEmpty) {
            return const Center(
              child: Text("Aucune question"),
            );
          }

          final question = questions[currentQuestion];

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuestionHeader(
                  current: currentQuestion + 1,
                  total: questions.length,
                ),
                const SizedBox(height: 25),
                Text(
                  question.statement,
                  style: const TextStyle(
                    color: Color(0xFF29258F),
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: buildQuestionWidget(question),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: answered ? () => nextQuestion(questions) : null,
                    child: Text(
                      currentQuestion == questions.length - 1 ? "Terminer" : "Suivant",
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
