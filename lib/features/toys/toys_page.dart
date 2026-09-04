import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/AppFontSize.dart';
import '../../core/constants/AppSpacing.dart';
import '../../models/toy_model.dart';
import '../../repository/toy_repository.dart';
import '../../routes/app_route.dart';

class ToysPage extends StatefulWidget {
  final String genre; // "fille" ou "garcon"

  const ToysPage({Key? key, required this.genre}) : super(key: key);

  @override
  State<ToysPage> createState() => _ToysPageState();
}

class _ToysPageState extends State<ToysPage> {
  final ToyRepository _toyRepository = ToyRepository();

  // Liste des tranches d'âge disponibles pour le filtrage
  final List<String> _ageCategories = [
    'Tous',
    '4-6 ans',
    '7-9 ans',
    '10-12 ans',
  ];
  String _selectedAge = 'Tous';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          widget.genre.toLowerCase() == 'fille'
              ? 'Jouets Filles'
              : 'Jouets Garçons',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),

            // 1. Barre Horizontale de Filtres par Âge
            _buildAgeFilterChips(),

            const SizedBox(height: AppSpacing.sm),

            // 2. Flux de Données Firestore (StreamBuilder)
            Expanded(
              child: StreamBuilder<List<ToyModel>>(
                stream: _toyRepository.getToysByGenreAndAge(
                  genre: widget.genre,
                  ageFilter: _selectedAge,
                ),
                builder: (context, snapshot) {
                  // État de chargement
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // État d'erreur
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erreur lors du chargement des jouets.',
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    );
                  }

                  final toys = snapshot.data ?? [];

                  // Liste vide
                  if (toys.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aucun jouet trouvé pour ce filtre.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  // Affichage de la liste
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    itemCount: toys.length,
                    itemBuilder: (context, index) {
                      return _buildToyCard(context, toys[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Barre Horizontale de Puces de Filtrage
  Widget _buildAgeFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: _ageCategories.length,
        itemBuilder: (context, index) {
          final age = _ageCategories[index];
          final isSelected = age == _selectedAge;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                age,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: AppFontSize.small,
                ),
              ),
              selected: isSelected,
              selectedColor: const Color(0xFF29B6F6),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF29B6F6)
                      : Colors.grey.shade300,
                ),
              ),
              showCheckmark: false,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedAge = age;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }

  // Carte Individuelle pour chaque Jouet
  Widget _buildToyCard(BuildContext context, ToyModel toy) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.pushNamed(
        AppRoutes.toyDetailName,
        pathParameters: {'toyId': toy.id},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: toy.imageUrl.isNotEmpty
                    ? Image.network(
                        toy.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.smart_toy_rounded,
                              color: Colors.grey,
                              size: 36,
                            ),
                      )
                    : const Icon(
                        Icons.smart_toy_rounded,
                        color: Colors.grey,
                        size: 36,
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    toy.nom,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSize.medium,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Âge : ${toy.ageRange}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: AppFontSize.small,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildStarRating(toy.note),
                ],
              ),
            ),
            Text(
              '${toy.prix.toInt()} FCFA',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppFontSize.medium,
                color: Color(0xFF29B6F6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Composant d'Évaluation par Étoiles
  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < fullStars ? Icons.star_rounded : Icons.star_border_rounded,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }
}

