import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../models/activity_model.dart';
import '../activity_service.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

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
    _minAgeController.dispose();
    _maxAgeController.dispose();
    _durationController.dispose();
    _rewardController.dispose();
    _successController.dispose();
    super.dispose();
  }

  Future<void> saveActivity() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final activity = ActivityModel(
      activityId: const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      minAge: int.parse(_minAgeController.text),
      maxAge: int.parse(_maxAgeController.text),
      activityType: activityType,
      competenceCategory: competenceCategory,
      duration: int.parse(_durationController.text),
      rewardPoints: int.parse(_rewardController.text),
      successThreshold: int.parse(_successController.text),
      progress: 0.0,
      createdAt: DateTime.now(),
    );

    await _service.addActivity(activity);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouvelle activité"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Titre",
              ),
              validator: (value) =>
                  value!.isEmpty ? "Champ obligatoire" : null,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Durée (en secondes)",
              ),
              validator: (value) =>
                  value!.isEmpty ? "Champ obligatoire" : null,
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: activityType,
              items: const [
                DropdownMenuItem(
                  value: "Lecture",
                  child: Text("Lecture"),
                ),
                DropdownMenuItem(
                  value: "Maths",
                  child: Text("Maths"),
                ),
                DropdownMenuItem(
                  value: "Mémoire",
                  child: Text("Mémoire"),
                ),
                DropdownMenuItem(
                  value: "Logique",
                  child: Text("Logique"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  activityType = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Type d'activité",
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: competenceCategory,
              items: const [
                DropdownMenuItem(
                  value: "Lecture",
                  child: Text("Lecture"),
                ),
                DropdownMenuItem(
                  value: "Maths",
                  child: Text("Maths"),
                ),
                DropdownMenuItem(
                  value: "Créativité",
                  child: Text("Créativité"),
                ),
                DropdownMenuItem(
                  value: "Logique",
                  child: Text("Logique"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  competenceCategory = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Compétence",
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                Expanded(
                  child: TextFormField(
                    controller: _minAgeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Age min",
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextFormField(
                    controller: _maxAgeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Age max",
                    ),
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
                    decoration: const InputDecoration(
                      labelText: "Points",
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextFormField(
                    controller: _successController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Seuil (%)",
                    ),
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
            )
          ],
        ),
      ),
    );
  }
}