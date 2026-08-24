import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../models/proposition.dart';
import '../../../models/question_model.dart';
import '../question_service.dart';

class AddQuestionPage extends StatefulWidget {
  final String activityId;

  const AddQuestionPage({
    super.key,
    required this.activityId,
  });

  @override
  State<AddQuestionPage> createState() =>
      _AddQuestionPageState();
}

class _AddQuestionPageState
    extends State<AddQuestionPage> {
  final _formKey = GlobalKey<FormState>();

  final QuestionService service = QuestionService();

  final statementController = TextEditingController();
  final objectiveController = TextEditingController();
  final imageUrlController = TextEditingController();

  final optionAController = TextEditingController();
  final optionBController = TextEditingController();
  final optionCController = TextEditingController();
  final optionDController = TextEditingController();

  final correctAnswerController =
      TextEditingController();

  final numericAnswerController =
      TextEditingController();

  final toleranceController =
      TextEditingController();

  final freeTextController =
      TextEditingController();

  QuestionType type =
      QuestionType.multipleChoice;

  bool caseSensitive = false;

  bool loading = false;

  @override
  void dispose() {
    statementController.dispose();
    objectiveController.dispose();
    imageUrlController.dispose();
    optionAController.dispose();
    optionBController.dispose();
    optionCController.dispose();
    optionDController.dispose();
    correctAnswerController.dispose();
    numericAnswerController.dispose();
    toleranceController.dispose();
    freeTextController.dispose();
    super.dispose();
  }

  Future<void> saveQuestion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    final question = QuestionModel(
      questionId: const Uuid().v4(),
      activityId: widget.activityId,
      type: type,
      statement: statementController.text.trim(),
      objective: objectiveController.text.trim(),
      image: imageUrlController.text.trim().isEmpty ? null : imageUrlController.text.trim(),
      options: [
        Proposition(
          id: 'A',
          texte: optionAController.text,
        ),
        Proposition(
          id: 'B',
          texte: optionBController.text,
        ),
        Proposition(
          id: 'C',
          texte: optionCController.text,
        ),
        Proposition(
          id: 'D',
          texte: optionDController.text,
        ),
      ],
      correctAnswer:
          correctAnswerController.text.trim(),
      correctNumericAnswer:
          numericAnswerController.text.isEmpty
              ? null
              : double.parse(
                  numericAnswerController.text),
      tolerance:
          toleranceController.text.isEmpty
              ? 0
              : double.parse(
                  toleranceController.text),
      freeTextAnswer:
          freeTextController.text.trim(),
      caseSensitive: caseSensitive,
      createdAt: DateTime.now(),
    );

    await service.addQuestion(
      widget.activityId,
      question,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Nouvelle question")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            DropdownButtonFormField<QuestionType>(
              value: type,
              decoration: const InputDecoration(
                labelText: "Type",
              ),
              items: QuestionType.values.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  type = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: statementController,
              decoration: const InputDecoration(
                labelText: "Question",
              ),
            ),

            const SizedBox(height: 20),

            if (type ==
                QuestionType.multipleChoice) ...[
              TextFormField(
                controller: optionAController,
                decoration: const InputDecoration(
                  labelText: "Réponse A",
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: optionBController,
                decoration: const InputDecoration(
                  labelText: "Réponse B",
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: optionCController,
                decoration: const InputDecoration(
                  labelText: "Réponse C",
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: optionDController,
                decoration: const InputDecoration(
                  labelText: "Réponse D",
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller:
                    correctAnswerController,
                decoration: const InputDecoration(
                  labelText:
                      "Bonne réponse",
                ),
              ),
            ],

            if (type ==
                QuestionType.numeric) ...[
              TextFormField(
                controller:
                    numericAnswerController,
                keyboardType:
                    TextInputType.number,
                decoration: const InputDecoration(
                  labelText:
                      "Bonne réponse",
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller:
                    toleranceController,
                keyboardType:
                    TextInputType.number,
                decoration: const InputDecoration(
                  labelText:
                      "Tolérance",
                ),
              ),
            ],

            if (type ==
                QuestionType.text) ...[
              TextFormField(
                controller:
                    freeTextController,
                decoration: const InputDecoration(
                  labelText:
                      "Bonne réponse",
                ),
              ),

              SwitchListTile(
                value: caseSensitive,
                title: const Text(
                    "Respecter la casse"),
                onChanged: (value) {
                  setState(() {
                    caseSensitive = value;
                  });
                },
              ),
            ],

            const SizedBox(height: 30),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed:
                    loading ? null : saveQuestion,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Enregistrer"),
              ),
            )
          ],
        ),
      ),
    );
  }
}