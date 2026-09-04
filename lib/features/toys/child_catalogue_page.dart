import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/toy_model.dart';
import '../../repository/toy_repository.dart';
import '../../routes/app_route.dart';
import '../children/children_profil.dart';

String _bucketPourAge(int age) {
  if (age <= 6) return '4-6 ans';
  if (age <= 9) return '7-9 ans';
  return '10-12 ans';
}

String _normaliserGenre(String genre) {
  final g = genre.trim().toLowerCase();
  if (g.contains('gar')) return 'garcon';
  if (g.contains('fil')) return 'fille';
  return g;
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

class ChildCataloguePage extends ConsumerStatefulWidget {
  final String enfantId;

  const ChildCataloguePage({super.key, required this.enfantId});

  @override
  ConsumerState<ChildCataloguePage> createState() => _ChildCataloguePageState();
}

class _ChildCataloguePageState extends ConsumerState<ChildCataloguePage> {
  final ToyRepository _toyRepository = ToyRepository();

  @override
  Widget build(BuildContext context) {
    final enfantAsync = ref.watch(enfantParIdProvider(widget.enfantId));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Mon Catalogue',
          style: TextStyle(
            color: Color(0xFF29258F),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: enfantAsync.when(
        data: (enfant) {
          if (enfant == null) {
            return const Center(child: Text('Enfant introuvable.'));
          }
          final age = _calculerAge(enfant.dateNaissance);
          final bucket = _bucketPourAge(age);
          final genre = _normaliserGenre(enfant.genre);

          return StreamBuilder<List<ToyModel>>(
            stream: _toyRepository.getToysByGenreAndAge(
              genre: genre,
              ageFilter: bucket,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                );
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Erreur de chargement.'));
              }

              final jouets = snapshot.data ?? [];

              if (jouets.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun jouet disponible pour le moment 🎁',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: jouets.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final jouet = jouets[index];
                  return _buildToyCard(jouet);
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
        ),
        error: (_, __) => const Center(child: Text('Erreur de chargement.')),
      ),
    );
  }

  Widget _buildToyCard(ToyModel jouet) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.childToyDetailName,
          pathParameters: {'toyId': jouet.id},
          queryParameters: {'enfantId': widget.enfantId},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                jouet.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.toys, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jouet.nom,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < (jouet.note ?? 5)
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: const Color(0xFFFFB800),
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${jouet.prix.toStringAsFixed(0)} F',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
