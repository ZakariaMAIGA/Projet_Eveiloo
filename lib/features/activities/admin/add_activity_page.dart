import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';

import '../../../models/activity_model.dart';
import '../../../routes/app_route.dart';
import '../activity_service.dart';
import '../widgets/image_url_validation.dart';

String? _validateInteger(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Champ obligatoire';
  }
  return int.tryParse(value.trim()) == null ? 'Entrez un nombre entier' : null;
}

String? _validateAge(String? value) {
  final error = _validateInteger(value);
  if (error != null) return error;

  final age = int.parse(value!.trim());
  return age < 0 || age > 12
      ? 'L’âge doit être compris entre 0 et 12 ans'
      : null;
}

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _objectiveController = TextEditingController();
  final _imageController = TextEditingController();

  final _minAgeController = TextEditingController();
  final _maxAgeController = TextEditingController();
  final _durationController = TextEditingController();
  final _rewardController = TextEditingController();
  final _successController = TextEditingController();

  final ActivityService _service = ActivityService();

  String activityType = "Lecture";
  String competenceCategory = "Lecture";

  bool isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _objectiveController.dispose();
    _imageController.dispose();
    _minAgeController.dispose();
    _maxAgeController.dispose();
    _durationController.dispose();
    _rewardController.dispose();
    _successController.dispose();
    super.dispose();
  }

  Future<void> saveActivity() async {
    if (!_formKey.currentState!.validate()) return;

    final minAge = int.parse(_minAgeController.text.trim());
    final maxAge = int.parse(_maxAgeController.text.trim());
    if (minAge > maxAge) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'L’âge minimum ne peut pas être supérieur à l’âge maximum',
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final activity = ActivityModel(
        activityId: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        objective: _objectiveController.text.trim().isEmpty
            ? null
            : _objectiveController.text.trim(),
        imageUrl: _imageController.text.trim().isEmpty
            ? null
            : _imageController.text.trim(),
        minAge: minAge,
        maxAge: maxAge,
        activityType: activityType,
        competenceCategory: competenceCategory,
        duration: int.parse(_durationController.text),
        rewardPoints: int.parse(_rewardController.text),
        successThreshold: int.parse(_successController.text),
        createdAt: DateTime.now(),
      );

      await _service.addActivity(activity);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activité ajoutée avec succès')),
        );
        context.go(AppRoutes.adminActivities);
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
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go(AppRoutes.adminActivities),
          tooltip: 'Retour à la liste des activités',
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Nouvelle activité"),
        actions: [
          IconButton(
            onPressed: () => context.go(AppRoutes.childActivities),
            tooltip: 'Mode enfant',
            icon: const Icon(Icons.child_care),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Titre"),
              validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Texte à lire",
                hintText:
                    "Écris ici l'histoire que l'enfant doit lire avant les questions",
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: _objectiveController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Objectif",
                hintText:
                    "Ex. Lis attentivement l'histoire et réponds aux questions",
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: _imageController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: "Image (URL)",
                hintText: "https://i.pinimg.com/.../image.jpg",
              ),
              validator: validateImageUrl,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Durée (en secondes)",
              ),
              validator: _validateInteger,
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue: activityType,
              items: const [
                DropdownMenuItem(value: "Lecture", child: Text("Lecture")),
                DropdownMenuItem(value: "Maths", child: Text("Maths")),
                DropdownMenuItem(value: "Mémoire", child: Text("Mémoire")),
                DropdownMenuItem(value: "Logique", child: Text("Logique")),
              ],
              onChanged: (value) {
                setState(() {
                  activityType = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Type d'activité"),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue: competenceCategory,
              items: const [
                DropdownMenuItem(value: "Lecture", child: Text("Lecture")),
                DropdownMenuItem(value: "Maths", child: Text("Maths")),
                DropdownMenuItem(
                  value: "Créativité",
                  child: Text("Créativité"),
                ),
                DropdownMenuItem(value: "Logique", child: Text("Logique")),
              ],
              onChanged: (value) {
                setState(() {
                  competenceCategory = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Compétence"),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _minAgeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Age min (0-12)",
                    ),
                    validator: _validateAge,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextFormField(
                    controller: _maxAgeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Age max (0-12)",
                    ),
                    validator: _validateAge,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _rewardController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Points"),
                    validator: _validateInteger,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextFormField(
                    controller: _successController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Seuil (%)"),
                    validator: _validateInteger,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveActivity,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Enregistrer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
