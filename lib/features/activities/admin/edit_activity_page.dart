import 'package:flutter/material.dart';

import '../../../models/activity_model.dart';
import '../activity_service.dart';
import '../widgets/image_url_validation.dart';

String? _validateAge(String? value) {
  if (value == null || value.trim().isEmpty) return 'Champ obligatoire';
  final age = int.tryParse(value.trim());
  if (age == null) return 'Entrez un nombre entier';
  return age < 0 || age > 12
      ? 'L’âge doit être compris entre 0 et 12 ans'
      : null;
}

class EditActivityPage extends StatefulWidget {
  final ActivityModel activity;

  const EditActivityPage({
    super.key,
    required this.activity,
  });

  @override
  State<EditActivityPage> createState() => _EditActivityPageState();
}

class _EditActivityPageState extends State<EditActivityPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController imageController;
  late TextEditingController objectiveController;
  late TextEditingController minAgeController;
  late TextEditingController maxAgeController;
  late TextEditingController rewardController;
  late TextEditingController successController;

  late String activityType;
  late String competenceCategory;

  bool loading = false;

  final ActivityService service = ActivityService();

  String? _validateMaxAge(String? value) {
    final error = _validateAge(value);
    if (error != null) return error;

    final minAge = int.tryParse(minAgeController.text.trim());
    final maxAge = int.tryParse(value!.trim());
    if (minAge != null && maxAge != null && minAge > maxAge) {
      return 'L’âge maximum doit être supérieur ou égal à l’âge minimum';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.activity.title);

    descriptionController =
        TextEditingController(text: widget.activity.description);

    imageController =
        TextEditingController(text: widget.activity.imageUrl ?? '');

    objectiveController =
        TextEditingController(text: widget.activity.objective ?? '');

    minAgeController =
        TextEditingController(text: widget.activity.minAge.toString());

    maxAgeController =
        TextEditingController(text: widget.activity.maxAge.toString());

    rewardController =
        TextEditingController(text: widget.activity.rewardPoints.toString());

    successController =
        TextEditingController(text: widget.activity.successThreshold.toString());

    activityType = widget.activity.activityType;
    competenceCategory = widget.activity.competenceCategory;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    objectiveController.dispose();
    minAgeController.dispose();
    maxAgeController.dispose();
    rewardController.dispose();
    successController.dispose();
    super.dispose();
  }

  Future<void> updateActivity() async {
    if (!_formKey.currentState!.validate()) return;

    final minAge = int.tryParse(minAgeController.text.trim());
    final maxAge = int.tryParse(maxAgeController.text.trim());
    if (minAge == null || maxAge == null) return;
    if (minAge > maxAge) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
          'L’âge minimum ne peut pas être supérieur à l’âge maximum',
        )),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final activity = widget.activity.copyWith(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        imageUrl: imageController.text.trim(),
        objective: objectiveController.text.trim(),
        minAge: minAge,
        maxAge: maxAge,
        activityType: activityType,
        competenceCategory: competenceCategory,
        rewardPoints: int.parse(rewardController.text),
        successThreshold: int.parse(successController.text),
      );

      await service.updateActivity(activity);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activité modifiée avec succès')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          tooltip: 'Retour à la liste des activités',
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Modifier activité"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Titre",
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Texte à lire",
                hintText: "Écris ici l'histoire que l'enfant doit lire avant les questions",
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: objectiveController,
              decoration: const InputDecoration(
                labelText: "Objectif",
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: "Image",
                hintText: "https://i.pinimg.com/.../image.jpg",
              ),
              validator: validateImageUrl,
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue: activityType,
              items: const [
                DropdownMenuItem(
                    value: "Lecture",
                    child: Text("Lecture")),
                DropdownMenuItem(
                    value: "Maths",
                    child: Text("Maths")),
                DropdownMenuItem(
                    value: "Mémoire",
                    child: Text("Mémoire")),
                DropdownMenuItem(
                    value: "Logique",
                    child: Text("Logique")),
              ],
              onChanged: (value) {
                setState(() {
                  activityType = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue: competenceCategory,
              items: const [
                DropdownMenuItem(
                    value: "Lecture",
                    child: Text("Lecture")),
                DropdownMenuItem(
                    value: "Maths",
                    child: Text("Maths")),
                DropdownMenuItem(
                    value: "Créativité",
                    child: Text("Créativité")),
                DropdownMenuItem(
                    value: "Logique",
                    child: Text("Logique")),
              ],
              onChanged: (value) {
                setState(() {
                  competenceCategory = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                Expanded(
                  child: TextFormField(
                    controller: minAgeController,
                    keyboardType: TextInputType.number,
                    decoration:
                      const InputDecoration(labelText: "Age min (0-12)"),
                    validator: _validateAge,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextFormField(
                    controller: maxAgeController,
                    keyboardType: TextInputType.number,
                    decoration:
                      const InputDecoration(labelText: "Age max (0-12)"),
                    validator: _validateMaxAge,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                Expanded(
                  child: TextFormField(
                    controller: rewardController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: "Points"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextFormField(
                    controller: successController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: "Seuil"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : updateActivity,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Modifier"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}