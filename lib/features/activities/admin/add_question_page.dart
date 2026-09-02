import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../models/activity_model.dart';
import '../../../models/proposition.dart';
import '../../../models/question_model.dart';
import '../question_service.dart';
import '../widgets/image_url_validation.dart';
import '../widgets/question_answer_utils.dart';
import '../child/activity_play_page.dart';

String? _validateDouble(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return double.tryParse(value.trim()) == null
      ? 'Entrez un nombre valide'
      : null;
}

/// Retourne l'URL saisie ou null si le champ est vide.
String? _optionalUrl(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

class AddQuestionPage extends StatefulWidget {
  final String activityId;

  /// Activité associée (optionnelle) : permet de lancer un test du parcours
  /// enfant directement depuis la création de question.
  final ActivityModel? activity;

  const AddQuestionPage({
    super.key,
    required this.activityId,
    this.activity,
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

  final optionAImageUrlController = TextEditingController();
  final optionBImageUrlController = TextEditingController();
  final optionCImageUrlController = TextEditingController();
  final optionDImageUrlController = TextEditingController();

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
    optionAImageUrlController.dispose();
    optionBImageUrlController.dispose();
    optionCImageUrlController.dispose();
    optionDImageUrlController.dispose();
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

    try {
      final options = [
        Proposition(
          id: 'A',
          texte: optionAController.text.trim(),
          imageUrl: _optionalUrl(optionAImageUrlController.text),
        ),
        Proposition(
          id: 'B',
          texte: optionBController.text.trim(),
          imageUrl: _optionalUrl(optionBImageUrlController.text),
        ),
        Proposition(
          id: 'C',
          texte: optionCController.text.trim(),
          imageUrl: _optionalUrl(optionCImageUrlController.text),
        ),
        Proposition(
          id: 'D',
          texte: optionDController.text.trim(),
          imageUrl: _optionalUrl(optionDImageUrlController.text),
        ),
      ];
      final normalizedAnswer = type == QuestionType.multipleChoice
          ? normalizeChoiceAnswer(correctAnswerController.text, options)
          : correctAnswerController.text.trim();
      if (type == QuestionType.multipleChoice && normalizedAnswer == null) {
        throw const FormatException(
          'Indiquez la lettre ou le texte exact d’une réponse',
        );
      }

      final question = QuestionModel(
        questionId: const Uuid().v4(),
        activityId: widget.activityId,
        type: type,
        statement: statementController.text.trim(),
        objective: objectiveController.text.trim(),
        image: imageUrlController.text.trim().isEmpty
            ? null
            : imageUrlController.text.trim(),
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
        createdAt: DateTime.now(),
      );

      await service.addQuestion(widget.activityId, question);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question ajoutée avec succès')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible d\'enregistrer : $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              tooltip: 'Retour aux questions',
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text("Nouvelle question"),
            actions: [
              if (widget.activity != null)
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ActivityPlayPage(activity: widget.activity!),
                    ),
                  ),
                  tooltip: 'Tester comme un enfant',
                  icon: const Icon(Icons.play_circle_outline),
                ),
            ],
          ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            DropdownButtonFormField<QuestionType>(
              initialValue: type,
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

            TextFormField(
              controller: imageUrlController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: "Image de la question (URL)",
                hintText: "https://i.pinimg.com/.../image.jpg",
              ),
              validator: validateImageUrl,
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
                controller: optionAImageUrlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: "Image réponse A (URL)",
                  hintText: "https://i.pinimg.com/.../image.jpg",
                ),
                validator: validateImageUrl,
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
                controller: optionBImageUrlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: "Image réponse B (URL)",
                  hintText: "https://i.pinimg.com/.../image.jpg",
                ),
                validator: validateImageUrl,
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
                controller: optionCImageUrlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: "Image réponse C (URL)",
                  hintText: "https://i.pinimg.com/.../image.jpg",
                ),
                validator: validateImageUrl,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: optionDController,
                decoration: const InputDecoration(
                  labelText: "Réponse D",
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: optionDImageUrlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: "Image réponse D (URL)",
                  hintText: "https://i.pinimg.com/.../image.jpg",
                ),
                validator: validateImageUrl,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller:
                    correctAnswerController,
                decoration: const InputDecoration(
                  labelText:
                    "Bonne réponse (lettre ou texte)",
                  hintText: "Ex. A ou Dans la grotte sombre",
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
                validator: _validateDouble,
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
                validator: _validateDouble,
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