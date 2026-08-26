import 'package:flutter/material.dart';

import '../../../models/proposition.dart';
import '../../../models/question_model.dart';
import '../question_service.dart';
import '../widgets/question_answer_utils.dart';

class EditQuestionPage extends StatefulWidget {
  final String activityId;
  final QuestionModel question;

  const EditQuestionPage({
    super.key,
    required this.activityId,
    required this.question,
  });

  @override
  State<EditQuestionPage> createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  final _formKey = GlobalKey<FormState>();

  final QuestionService service = QuestionService();

  late TextEditingController statementController;

  late TextEditingController optionAController;
  late TextEditingController optionBController;
  late TextEditingController optionCController;
  late TextEditingController optionDController;

  late TextEditingController correctAnswerController;
  late TextEditingController numericAnswerController;
  late TextEditingController toleranceController;
  late TextEditingController freeTextController;

  late QuestionType type;

  bool caseSensitive = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    final options = widget.question.options;

    statementController =
        TextEditingController(text: widget.question.statement);

    optionAController =
        TextEditingController(text: options.isNotEmpty ? options[0].texte : "");

    optionBController =
        TextEditingController(text: options.length > 1 ? options[1].texte : "");

    optionCController =
        TextEditingController(text: options.length > 2 ? options[2].texte : "");

    optionDController =
        TextEditingController(text: options.length > 3 ? options[3].texte : "");

    correctAnswerController =
        TextEditingController(text: widget.question.correctAnswer);

    numericAnswerController = TextEditingController(
      text: widget.question.correctNumericAnswer?.toString() ?? "",
    );

    toleranceController = TextEditingController(
      text: widget.question.tolerance.toString(),
    );

    freeTextController = TextEditingController(
      text: widget.question.freeTextAnswer,
    );

    type = widget.question.type;
    caseSensitive = widget.question.caseSensitive;
  }

  @override
  void dispose() {
    statementController.dispose();
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

  Future<void> updateQuestion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    final options = [
      Proposition(id: 'A', texte: optionAController.text.trim()),
      Proposition(id: 'B', texte: optionBController.text.trim()),
      Proposition(id: 'C', texte: optionCController.text.trim()),
      Proposition(id: 'D', texte: optionDController.text.trim()),
    ];
    final normalizedAnswer = type == QuestionType.multipleChoice
        ? normalizeChoiceAnswer(correctAnswerController.text, options)
        : correctAnswerController.text.trim();
    if (type == QuestionType.multipleChoice && normalizedAnswer == null) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
          'Indiquez la lettre ou le texte exact d’une réponse',
        )),
      );
      return;
    }

    try {
      final updatedQuestion = widget.question.copyWith(
        statement: statementController.text.trim(),
        type: type,
        options: options,
        correctAnswer: normalizedAnswer ?? '',
        correctNumericAnswer: numericAnswerController.text.isEmpty
            ? null
            : double.parse(numericAnswerController.text),
        tolerance: toleranceController.text.isEmpty
            ? 0
            : double.parse(toleranceController.text),
        freeTextAnswer: freeTextController.text.trim(),
        caseSensitive: caseSensitive,
      );

      await service.updateQuestion(widget.activityId, updatedQuestion);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question modifiée avec succès')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible de modifier : $error')),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Widget buildDynamicForm() {
    switch (type) {
      case QuestionType.multipleChoice:
        return Column(
          children: [
            TextFormField(
              controller: optionAController,
              decoration: const InputDecoration(labelText: "Réponse A"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: optionBController,
              decoration: const InputDecoration(labelText: "Réponse B"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: optionCController,
              decoration: const InputDecoration(labelText: "Réponse C"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: optionDController,
              decoration: const InputDecoration(labelText: "Réponse D"),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: correctAnswerController,
              decoration: const InputDecoration(
                labelText: "Bonne réponse (lettre ou texte)",
                hintText: "Ex. A ou Dans la grotte sombre",
              ),
            ),
          ],
        );

      case QuestionType.numeric:
        return Column(
          children: [
            TextFormField(
              controller: numericAnswerController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Bonne réponse",
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: toleranceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Tolérance",
              ),
            ),
          ],
        );

      case QuestionType.text:
        return Column(
          children: [
            TextFormField(
              controller: freeTextController,
              decoration: const InputDecoration(
                labelText: "Bonne réponse",
              ),
            ),
            SwitchListTile(
              value: caseSensitive,
              title: const Text("Respecter la casse"),
              onChanged: (value) {
                setState(() {
                  caseSensitive = value;
                });
              },
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          tooltip: 'Retour aux questions',
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Modifier une question"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            DropdownButtonFormField<QuestionType>(
              initialValue: type,
              decoration: const InputDecoration(
                labelText: "Type de question",
              ),
              items: QuestionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
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

            buildDynamicForm(),

            const SizedBox(height: 30),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : updateQuestion,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Mettre à jour"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}