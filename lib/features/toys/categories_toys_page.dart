import 'package:eveiloo_enfant/models/CategorieJouetModel.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/AppFontSize.dart';
import '../../core/constants/AppSpacing.dart';
import '../../repository/toy_repository.dart';

class CategoriesToysPage extends StatefulWidget {
  /// null = mode parent (accès admin, panier). non-null = mode enfant
  /// (lecture seule + favoris uniquement).
  final String? enfantId;

  const CategoriesToysPage({Key? key, this.enfantId}) : super(key: key);

  @override
  State<CategoriesToysPage> createState() => _CategoriesToysPageState();
}

class _CategoriesToysPageState extends State<CategoriesToysPage> {
  final ToyRepository _toyRepository = ToyRepository();
  String _selectedGenre = 'fille';

  bool get modeEnfant => widget.enfantId != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Catégories de Jouets'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: modeEnfant
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  tooltip: 'Espace Admin',
                  onPressed: () => context.push(AppRoutes.adminToys),
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  tooltip: 'Mon panier',
                  onPressed: () => context.pushNamed(AppRoutes.cartName),
                ),
              ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explorez par catégorie',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSize.large,
                ),
              ),
              AppSpacing.verticalGapXs,
              Text(
                modeEnfant
                    ? 'Découvre des jouets adaptés à ton âge !'
                    : 'Sélectionnez un univers de jouets adapté au développement de votre enfant.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontSize: AppFontSize.medium,
                ),
              ),
              AppSpacing.verticalGapMd,

              // --- SÉLECTEUR DE GENRE (FILLE / GARÇON) ---
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Fille')),
                      selected: _selectedGenre == 'fille',
                      selectedColor: Colors.pink.shade100,
                      labelStyle: TextStyle(
                        color: _selectedGenre == 'fille'
                            ? Colors.pink.shade900
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedGenre = 'fille');
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Garçon')),
                      selected: _selectedGenre == 'garcon',
                      selectedColor: Colors.blue.shade100,
                      labelStyle: TextStyle(
                        color: _selectedGenre == 'garcon'
                            ? Colors.blue.shade900
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedGenre = 'garcon');
                      },
                    ),
                  ),
                ],
              ),

              AppSpacing.verticalGapLg,

              // --- LISTE DE CATÉGORIES ---
              Expanded(
                child: StreamBuilder<List<CategorieJouetModel>>(
                  stream: _toyRepository.getCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erreur lors du chargement des catégories.',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      );
                    }

                    final categories = snapshot.data ?? [];

                    if (categories.isEmpty) {
                      return const Center(
                        child: Text(
                          'Aucune catégorie disponible pour le moment.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return GridView.builder(
                      itemCount: categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 280,
                            crossAxisSpacing: AppSpacing.md,
                            mainAxisSpacing: AppSpacing.md,
                            childAspectRatio: 0.85,
                          ),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return _buildCategoryCard(context, category);
                      },
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

  Widget _buildCategoryCard(
    BuildContext context,
    CategorieJouetModel category,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          final params = <String, String>{
            'genre': _selectedGenre,
            'categorieId': category.categorieId,
            'categorieNom': category.nom,
            if (widget.enfantId != null) 'enfantId': widget.enfantId!,
          };
          context.pushNamed('toys', queryParameters: params);
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor.withOpacity(0.15),
                      theme.primaryColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: category.icone != null && category.icone!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          category.icone!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.category_rounded,
                            size: 28,
                            color: theme.primaryColor,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.category_rounded,
                        size: 28,
                        color: theme.primaryColor,
                      ),
              ),
              AppSpacing.verticalGapSm,
              Text(
                category.nom,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSize.medium,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.verticalGapXs,
              Text(
                category.description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: AppFontSize.caption,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
