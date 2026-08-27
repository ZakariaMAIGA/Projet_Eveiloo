import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/activity_model.dart';
import '../../../models/proposition.dart';
import '../../../models/question_model.dart';
import '../providers/question_provider.dart';
import '../activity_service.dart';
import '../widgets/answer_button.dart';
import '../widgets/question_header.dart';
import '../widgets/question_answer_utils.dart';
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
  bool readingStep = true;
  late int remainingSeconds;
  Timer? countdownTimer;
  bool activityFinished = false;
  int totalQuestionCount = 0;
  String? sessionId;
  String? selectedAnswer;
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startSession();
    remainingSeconds = widget.activity.duration;
    if (remainingSeconds > 0) {
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || activityFinished) return;
        if (remainingSeconds <= 1) {
          countdownTimer?.cancel();
          setState(() => remainingSeconds = 0);
          finishActivity();
          return;
        }
        setState(() => remainingSeconds--);
      });
    }
  }

  Future<void> _startSession() async {
    try {
      sessionId = await ActivityService().startActivitySession(
        widget.activity.activityId,
        widget.activity.duration,
      );
    } catch (_) {
      // The activity can still be played if the session marker cannot be written.
    }
  }

  bool get hasReadingStep {
    final category = widget.activity.competenceCategory.toLowerCase();
    final type = widget.activity.activityType.toLowerCase();
    return category.contains('lecture') || type.contains('lecture');
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    final currentSessionId = sessionId;
    if (currentSessionId != null) {
      ActivityService().endActivitySession(
        widget.activity.activityId,
        currentSessionId,
      );
    }
    textController.dispose();
    super.dispose();
  }

  void finishActivity([List<QuestionModel>? questions]) {
    if (activityFinished || !mounted) return;
    activityFinished = true;
    countdownTimer?.cancel();

    // La session de jeu est finie : l'activité passe "Terminée".
    // On persiste aussi le pourcentage réel obtenu par l'enfant.
    final total = questions?.length ?? totalQuestionCount;
    final percent =
        total == 0 ? 0.0 : ((score / total) * 100).clamp(0.0, 100.0);
    unawaited(
      ActivityService()
          .markActivityCompleted(widget.activity.activityId, percent),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ActivityResultPage(
          score: score,
          totalQuestions: questions?.length ?? totalQuestionCount,
          activity: widget.activity,
        ),
      ),
    );
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
      finishActivity(questions);
    }
  }

  void checkAnswer(QuestionModel question, dynamic answer) {
    if (answered) return;

    bool correct = false;

    switch (question.type) {
      case QuestionType.multipleChoice:
        // For multiple choice, answer is a Proposition object
        correct = answer is Proposition &&
          (answer.id.toLowerCase() == question.correctAnswer.toLowerCase() ||
            answer.texte.trim().toLowerCase() ==
              question.correctAnswer.trim().toLowerCase());
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
      score++;
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
          isCorrect: normalizeChoiceAnswer(
                question.correctAnswer,
                question.options,
              ) ==
              proposition.id,
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

  Widget buildReadingStep(int totalQuestions) {
    return SingleChildScrollView(
      child: Column(
        children: [
        QuestionHeader(
          current: 1,
          total: totalQuestions,
          title: widget.activity.title,
          onClose: () => Navigator.pop(context),
        ),
        const SizedBox(height: 10),
        _TimerBadge(seconds: remainingSeconds),
        const SizedBox(height: 48),
        const Text(
          'Histoire 1',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF29258F),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          widget.activity.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF29258F),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 28),
        if (widget.activity.imageUrl != null &&
            widget.activity.imageUrl!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              widget.activity.imageUrl!,
              height: 245,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, error, stackTrace) => const ColoredBox(
                color: Color(0xFFDDF4FB),
                child: Icon(Icons.broken_image_outlined,
                    color: Color(0xFF2D8DD5), size: 72),
              ),
            ),
          ),
        if (widget.activity.imageUrl == null ||
            widget.activity.imageUrl!.isEmpty)
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFDDF4FB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.menu_book_rounded,
                color: Color(0xFF2D8DD5), size: 72),
          ),
        const SizedBox(height: 38),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.activity.description,
            style: const TextStyle(
              color: Color(0xFF29258F),
              fontSize: 19,
              height: 1.25,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 36),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () => setState(() => readingStep = false),
            child: const Text('Suivant', style: TextStyle(fontSize: 23)),
          ),
        ),
        ],
      ),
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
          totalQuestionCount = questions.length;
          if (questions.isEmpty) {
            return const Center(
              child: Text("Aucune question"),
            );
          }

          if (hasReadingStep && readingStep) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: buildReadingStep(questions.length),
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
                  title: widget.activity.title,
                  onClose: () => Navigator.pop(context),
                ),
                const SizedBox(height: 10),
                _TimerBadge(seconds: remainingSeconds),
                const SizedBox(height: 20),
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

class _TimerBadge extends StatelessWidget {
  const _TimerBadge({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    final urgent = seconds <= 10;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: urgent ? const Color(0xFFFFE1E1) : const Color(0xFFDDF4FB),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_outlined,
                size: 20,
                color: urgent ? const Color(0xFFD93025) : const Color(0xFF2D8DD5)),
            const SizedBox(width: 5),
            Text(
              minutes > 0
                  ? '$minutes:${remaining.toString().padLeft(2, '0')}'
                  : '${remaining}s',
              style: TextStyle(
                color: urgent ? const Color(0xFFD93025) : const Color(0xFF29258F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
