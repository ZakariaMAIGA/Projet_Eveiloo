import 'package:flutter/material.dart';
import '../../core/constants/AppFontSize.dart';
import '../../core/constants/AppSpacing.dart';
import '../../models/category_model.dart';
import '../../models/toy_model.dart';
import '../../repository/toy_repository.dart';

class AdminToysPage extends StatefulWidget {
  final String? categorieId;
  final String? categorieNom;

  const AdminToysPage({Key? key, this.categorieId, this.categorieNom})
    : super(key: key);

  @override
  State<AdminToysPage> createState() => _AdminToysPageState();
}

class _AdminToysPageState extends State<AdminToysPage> {
  final ToyRepository _toyRepository = ToyRepository();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- FORMULAIRE D'AJOUT DE JOUET ---
  void _showAddToyDialog() {
    final formKey = GlobalKey<FormState>();
    final nomController = TextEditingController();
    final descriptionController = TextEditingController();
    final prixController = TextEditingController();
    final imageUrlController = TextEditingController();

    String selectedGenre = 'fille';
    String selectedAgeRange = '4-6 ans';
    String selectedCatId = widget.categorieId ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: AppSpacing.md,
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ajouter un Nouveau Jouet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Sélection dynamique de la catégorie via Firestore
                      StreamBuilder<List<CategoryModel>>(
                        stream: _toyRepository.getCategories(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final categories = snapshot.data!;

                          if (selectedCatId.isEmpty && categories.isNotEmpty) {
                            selectedCatId = categories.first.categorieId;
                          }

                          return DropdownButtonFormField<String>(
                            value: selectedCatId.isNotEmpty
                                ? selectedCatId
                                : null,
                            decoration: const InputDecoration(
                              labelText: 'Catégorie',
                              border: OutlineInputBorder(),
                            ),
                            items: categories.map((cat) {
                              return DropdownMenuItem(
                                value: cat.categorieId,
                                child: Text(cat.nom),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => selectedCatId = val);
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Nom du jouet
                      TextFormField(
                        controller: nomController,
                        decoration: const InputDecoration(
                          labelText: 'Nom du jouet',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Champ requis' : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Prix
                      TextFormField(
                        controller: prixController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Prix (FCFA)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Champ requis' : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // URL de l'image
                      TextFormField(
                        controller: imageUrlController,
                        decoration: const InputDecoration(
                          labelText: "URL de l'image",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Genre et Tranche d'âge
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedGenre,
                              decoration: const InputDecoration(
                                labelText: 'Genre',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'fille',
                                  child: Text('Fille'),
                                ),
                                DropdownMenuItem(
                                  value: 'garcon',
                                  child: Text('Garçon'),
                                ),
                              ],
                              onChanged: (val) =>
                                  setModalState(() => selectedGenre = val!),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedAgeRange,
                              decoration: const InputDecoration(
                                labelText: 'Âge',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Tous',
                                  child: Text('Tous'),
                                ),
                                DropdownMenuItem(
                                  value: '4-6 ans',
                                  child: Text('4-6 ans'),
                                ),
                                DropdownMenuItem(
                                  value: '7-9 ans',
                                  child: Text('7-9 ans'),
                                ),
                                DropdownMenuItem(
                                  value: '10-12 ans',
                                  child: Text('10-12 ans'),
                                ),
                              ],
                              onChanged: (val) =>
                                  setModalState(() => selectedAgeRange = val!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Description
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Bouton d'enregistrement
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final newToy = ToyModel(
                                id: '',
                                nom: nomController.text,
                                description: descriptionController.text,
                                prix: double.tryParse(prixController.text) ?? 0,
                                imageUrl: imageUrlController.text,
                                images: [],
                                categorieId: selectedCatId,
                                genre: selectedGenre,
                                ageRange: selectedAgeRange,
                                note: 5.0,
                                nombreAvis: 1,
                                tags: [],
                                competences: [],
                              );

                              await _toyRepository.addToy(newToy);

                              if (context.mounted) Navigator.pop(context);
                            }
                          },
                          child: const Text('Enregistrer le Jouet'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categorieNom ?? 'Gestion des Jouets'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _showAddToyDialog),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              // Barre de recherche
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Rechercher un jouet...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.xs,
                    horizontal: AppSpacing.md,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Contenu principal / Liste Firestore
              Expanded(
                child: StreamBuilder<List<ToyModel>>(
                  stream: _toyRepository.getToys(
                    categorieId: widget.categorieId,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erreur lors du chargement des jouets.',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      );
                    }

                    final allToys = snapshot.data ?? [];

                    final filteredToys = allToys.where((toy) {
                      return _searchQuery.isEmpty ||
                          toy.nom.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          );
                    }).toList();

                    if (filteredToys.isEmpty) {
                      return Center(
                        child: Text(
                          'Aucun jouet trouvé.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                            fontSize: AppFontSize.medium,
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${filteredToys.length} jouet(s) au total',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSize.semiLarge,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredToys.length,
                            itemBuilder: (context, index) {
                              final toy = filteredToys[index];
                              return _buildAdminToyCard(context, toy);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminToyCard(BuildContext context, ToyModel toy) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: toy.imageUrl.isNotEmpty
                    ? Image.network(toy.imageUrl, fit: BoxFit.cover)
                    : Icon(
                        Icons.smart_toy_rounded,
                        size: 36,
                        color: theme.primaryColor,
                      ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Contenu
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    toy.nom,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSize.medium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Âge : ${toy.ageRange} | Genre : ${toy.genre}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: AppFontSize.small,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${toy.note}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: AppFontSize.caption,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${toy.prix.toInt()} FCFA',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSize.semiLarge,
                    ),
                  ),
                ],
              ),
            ),

            // Actions d'administration
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _toyRepository.deleteToy(toy.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
