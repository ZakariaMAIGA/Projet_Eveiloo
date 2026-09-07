import 'package:eveiloo_enfant/core/constants/admin_ui.dart';
import 'package:eveiloo_enfant/widgets/admin_scaffold.dart';
import 'package:flutter/material.dart';

import '../../../models/CategorieJouetModel.dart';
import '../../../models/toy_model.dart';
import '../../../repository/toy_repository.dart';

/// Page admin "Ajouter un jouet". Respecte le même design que le reste du
/// back-office (AdminScaffold + AdminCard + AdminTextField).
class AddToyPage extends StatefulWidget {
  const AddToyPage({super.key});

  static const String route = '/admin/jouets/ajouter';

  @override
  State<AddToyPage> createState() => _AddToyPageState();
}

class _AddToyPageState extends State<AddToyPage> {
  final _formKey = GlobalKey<FormState>();
  final _toyRepository = ToyRepository();

  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prixController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _imagesController = TextEditingController();
  final _ageRangeController = TextEditingController();
  final _tagsController = TextEditingController();
  final _competencesController = TextEditingController();

  String? _categorieId;
  String _genre = 'fille';
  bool _isSaving = false;

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    _prixController.dispose();
    _imageUrlController.dispose();
    _imagesController.dispose();
    _ageRangeController.dispose();
    _tagsController.dispose();
    _competencesController.dispose();
    super.dispose();
  }

  List<String> _splitCsv(String value) =>
      value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final toy = ToyModel(
        id: '',
        nom: _nomController.text.trim(),
        description: _descriptionController.text.trim(),
        prix: double.tryParse(_prixController.text.replaceAll(',', '.')) ?? 0,
        imageUrl: _imageUrlController.text.trim(),
        images: _splitCsv(_imagesController.text),
        categorieId: _categorieId ?? '',
        genre: _genre,
        ageRange: _ageRangeController.text.trim(),
        note: 0,
        nombreAvis: 0,
        tags: _splitCsv(_tagsController.text),
        competences: _splitCsv(_competencesController.text),
      );

      await _toyRepository.addToy(toy);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jouet ajouté avec succès.')),
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
      title: 'Ajouter un jouet',
      currentRoute: '/admin/jouets',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminTextField(
                  label: 'Nom du jouet',
                  controller: _nomController,
                  hint: 'Ex: Puzzle Animaux',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                AdminTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  hint: 'Décris le jouet en quelques mots',
                  maxLines: 3,
                ),
                AdminTextField(
                  label: 'Prix (F CFA)',
                  controller: _prixController,
                  hint: 'Ex: 15000',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                AdminTextField(
                  label: 'Image principale (URL)',
                  controller: _imageUrlController,
                  hint: 'https://...',
                ),
                AdminTextField(
                  label: 'Autres images (séparées par des virgules)',
                  controller: _imagesController,
                  hint: 'https://..., https://...',
                ),
                _CategorieDropdown(
                  value: _categorieId,
                  onChanged: (v) => setState(() => _categorieId = v),
                ),
                AdminDropdownField<String>(
                  label: 'Genre',
                  value: _genre,
                  items: const [
                    DropdownMenuItem(value: 'fille', child: Text('Fille')),
                    DropdownMenuItem(value: 'garcon', child: Text('Garçon')),
                  ],
                  onChanged: (v) => setState(() => _genre = v ?? 'fille'),
                ),
                AdminTextField(
                  label: 'Tranche d\'âge',
                  controller: _ageRangeController,
                  hint: 'Ex: 4-6 ans',
                ),
                AdminTextField(
                  label: 'Tags (séparés par des virgules)',
                  controller: _tagsController,
                  hint: 'Ex: éducatif, bois, calme',
                ),
                AdminTextField(
                  label: 'Compétences développées (séparées par des virgules)',
                  controller: _competencesController,
                  hint: 'Ex: motricité fine, logique',
                ),
                const SizedBox(height: 4),
                AdminPrimaryButton(
                  label: 'Ajouter le jouet',
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

/// Sélection de la catégorie à partir de la collection Firestore CATEGORIES.
class _CategorieDropdown extends StatelessWidget {
  const _CategorieDropdown({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CategorieJouetModel>>(
      stream: ToyRepository().getCategories(),
      builder: (context, snapshot) {
        final categories = snapshot.data ?? [];
        return AdminDropdownField<String>(
          label: 'Catégorie',
          value: categories.any((c) => c.categorieId == value) ? value : null,
          items: [
            for (final c in categories)
              DropdownMenuItem(value: c.categorieId, child: Text(c.nom)),
          ],
          onChanged: onChanged,
        );
      },
    );
  }
}
