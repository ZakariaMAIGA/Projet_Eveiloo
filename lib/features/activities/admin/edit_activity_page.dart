import 'package:flutter/material.dart';

import '../../../models/activity_model.dart';
import '../activity_service.dart';

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

    setState(() {
      loading = true;
    });

    final activity = widget.activity.copyWith(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      imageUrl: imageController.text.trim(),
      objective: objectiveController.text.trim(),
      minAge: int.parse(minAgeController.text),
      maxAge: int.parse(maxAgeController.text),
      activityType: activityType,
      competenceCategory: competenceCategory,
      rewardPoints: int.parse(rewardController.text),
      successThreshold: int.parse(successController.text),
    );

    await service.updateActivity(activity);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                labelText: "Description",
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
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: activityType,
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
              value: competenceCategory,
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
                        const InputDecoration(labelText: "Age min"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextFormField(
                    controller: maxAgeController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: "Age max"),
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