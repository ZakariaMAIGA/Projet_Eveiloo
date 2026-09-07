import 'package:eveiloo_enfant/core/constants/admin_ui.dart';
import 'package:eveiloo_enfant/widgets/admin_scaffold.dart';
import 'package:flutter/material.dart';

import '../../../models/TutorielModel.dart';
import '../../../repository/tutoriel_repository.dart';

/// Page admin "Ajouter un tutoriel".
class AddTutorielPage extends StatefulWidget {
  const AddTutorielPage({super.key});

  static const String route = '/admin/tutoriels/ajouter';

  @override
  State<AddTutorielPage> createState() => _AddTutorielPageState();
}

class _AddTutorielPageState extends State<AddTutorielPage> {
  final _formKey = GlobalKey<FormState>();
  final _tutorielRepository = TutorielRepository();

  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlVideoController = TextEditingController();
  final _urlImageController = TextEditingController();
  final _ageMinController = TextEditingController(text: '0');
  final _ageMaxController = TextEditingController(text: '12');
  final _categorieController = TextEditingController();
  final _materielsController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    _urlVideoController.dispose();
    _urlImageController.dispose();
    _ageMinController.dispose();
    _ageMaxController.dispose();
    _categorieController.dispose();
    _materielsController.dispose();
    super.dispose();
  }

  List<String> _splitCsv(String value) =>
      value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final tutoriel = TutorielModel(
        tutorielId: '',
        titre: _titreController.text.trim(),
        description: _descriptionController.text.trim(),
        urlVideo: _urlVideoController.text.trim(),
        urlImage: _urlImageController.text.trim(),
        ageMin: int.tryParse(_ageMinController.text) ?? 0,
        ageMax: int.tryParse(_ageMaxController.text) ?? 0,
        categorie: _categorieController.text.trim(),
        materielIds: _splitCsv(_materielsController.text),
      );

      await _tutorielRepository.ajouter(tutoriel);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutoriel ajouté avec succès.')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Ajouter un tutoriel',
      currentRoute: '/admin/tutoriels',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminTextField(
                  label: 'Titre',
                  controller: _titreController,
                  hint: 'Ex: Construire une tour en Lego',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                AdminTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  hint: 'Décris le contenu du tutoriel',
                  maxLines: 3,
                ),
                AdminTextField(
                  label: 'Lien de la vidéo',
                  controller: _urlVideoController,
                  hint: 'https://...',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                AdminTextField(
                  label: 'Image de couverture (URL)',
                  controller: _urlImageController,
                  hint: 'https://...',
                ),
                Row(
                  children: [
                    Expanded(
                      child: AdminTextField(
                        label: 'Âge min',
                        controller: _ageMinController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AdminTextField(
                        label: 'Âge max',
                        controller: _ageMaxController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                AdminTextField(
                  label: 'Catégorie',
                  controller: _categorieController,
                  hint: 'Ex: Créativité, Motricité...',
                ),
                AdminTextField(
                  label: 'Jouets liés (IDs séparés par des virgules)',
                  controller: _materielsController,
                  hint: 'Optionnel',
                ),
                const SizedBox(height: 4),
                AdminPrimaryButton(
                  label: 'Ajouter le tutoriel',
                  icon: Icons.check_rounded,
                  isLoading: _isSaving,
                  onPressed: _enregistrer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
