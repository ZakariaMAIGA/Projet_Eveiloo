import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/AppFontSize.dart';
import '../../core/constants/AppSpacing.dart';
import '../../models/toy_model.dart';
import '../../repository/toy_repository.dart';
import '../../routes/app_route.dart';
import '../children/children_profil.dart'; // enfantParIdProvider

/// Détermine le bucket d'âge (schéma existant en base : "4-6 ans",
/// "7-9 ans", "10-12 ans") correspondant à l'âge réel d'un enfant.
String _bucketPourAge(int age) {
  if (age <= 6) return '4-6 ans';
  if (age <= 9) return '7-9 ans';
  return '10-12 ans';
}

class ToysPage extends ConsumerStatefulWidget {
  final String genre; // "fille" ou "garcon"
  final String? categorieId;
  final String? categorieNom;

  /// null = mode parent (filtre d'âge manuel via chips).
  /// non-null = mode enfant (filtre d'âge automatique, pas de chips).
  final String? enfantId;

  const ToysPage({
    Key? key,
    required this.genre,
    this.categorieId,
    this.categorieNom,
    this.enfantId,
  }) : super(key: key);

  @override
  ConsumerState<ToysPage> createState() => _ToysPageState();
}

class _ToysPageState extends ConsumerState<ToysPage> {
  final ToyRepository _toyRepository = ToyRepository();

  final List<String> _ageCategories = [
    'Tous',
    '4-6 ans',
    '7-9 ans',
    '10-12 ans',
  ];
  String _selectedAge = 'Tous';

  bool get modeEnfant => widget.enfantId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          widget.categorieNom ??
              (widget.genre.toLowerCase() == 'fille'
                  ? 'Jouets Filles'
                  : 'Jouets Garçons'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: modeEnfant ? _buildCorpsEnfant() : _buildCorpsParent(),
      ),
    );
  }

  // -----------------------------------------------------------------
  // MODE PARENT : filtre d'âge manuel via chips.
  // -----------------------------------------------------------------
  Widget _buildCorpsParent() {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.sm),
        _buildAgeFilterChips(),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: StreamBuilder<List<ToyModel>>(
            stream: _toyRepository.getToysByGenreAndAge(
              genre: widget.genre,
              ageFilter: _selectedAge,
              categorieId: widget.categorieId,
            ),
            builder: (context, snapshot) => _buildListe(snapshot),
          ),
        ),
      ],
    );
  }

  // -----------------------------------------------------------------
  // MODE ENFANT : pas de chips, filtre automatique selon son âge.
  // -----------------------------------------------------------------
  Widget _buildCorpsEnfant() {
    final enfantAsync = ref.watch(enfantParIdProvider(widget.enfantId!));

    return enfantAsync.when(
      data: (enfant) {
        if (enfant == null) {
          return const Center(child: Text('Enfant introuvable.'));
        }
        final age = _calculerAge(enfant.dateNaissance);
        final bucket = _bucketPourAge(age);

        return StreamBuilder<List<ToyModel>>(
          stream: _toyRepository.getToysByGenreAndAge(
            genre: widget.genre,
            ageFilter: bucket,
            categorieId: widget.categorieId,
          ),
          builder: (context, snapshot) => _buildListe(snapshot),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Erreur de chargement.')),
    );
  }

  int _calculerAge(String dateNaissance) {
    final dateStr = dateNaissance.trim();
    if (dateStr.isEmpty) return 0;
    final parts = dateStr.split('/');
    if (parts.length != 3) return 0;
    final jour = int.tryParse(parts[0]);
    final mois = int.tryParse(parts[1]);
    final annee = int.tryParse(parts[2]);
    if (jour == null || mois == null || annee == null) return 0;
    final naissance = DateTime(annee, mois, jour);
    final now = DateTime.now();
    var age = now.year - naissance.year;
    if (now.month < naissance.month ||
        (now.month == naissance.month && now.day < naissance.day)) {
      age--;
    }
    return age < 0 ? 0 : age;
  }

  Widget _buildListe(AsyncSnapshot<List<ToyModel>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(
        child: Text(
          'Erreur lors du chargement des jouets.',
          style: TextStyle(color: Colors.red.shade700),
        ),
      );
    }

    final toys = snapshot.data ?? [];

    if (toys.isEmpty) {
      return const Center(
        child: Text(
          'Aucun jouet trouvé pour ce filtre.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      itemCount: toys.length,
      itemBuilder: (context, index) => _buildToyCard(context, toys[index]),
    );
  }

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
                if (selected) setState(() => _selectedAge = age);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildToyCard(BuildContext context, ToyModel toy) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.pushNamed(
        AppRoutes.toyDetailName,
        pathParameters: {'toyId': toy.id},
        queryParameters: {
          if (widget.enfantId != null) 'enfantId': widget.enfantId!,
        },
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
