import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/provider/tutoriel_provider.dart';
import '../../models/TutorielModel.dart';
import '../../routes/app_route.dart';
import 'tutorial_detail_page.dart';

class TutorialsPage extends ConsumerStatefulWidget {
  final String? enfantId; // null = parent (lecture seule), non-null = enfant

  const TutorialsPage({super.key, required this.enfantId});

  @override
  ConsumerState<TutorialsPage> createState() => _TutorialsPageState();
}

class _TutorialsPageState extends ConsumerState<TutorialsPage> {
  String _filtreActif = 'Tous';

  @override
  Widget build(BuildContext context) {
    final tutorielsAsync = ref.watch(tutorielsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: tutorielsAsync.when(
          data: (tutoriels) {
            final categories = <String>[
              'Tous',
              ...{for (final t in tutoriels) t.categorie},
            ];
            final filtres = _filtreActif == 'Tous'
                ? tutoriels
                : tutoriels.where((t) => t.categorie == _filtreActif).toList();

            return Column(
              children: [
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                    child: Text(
                      'Tutoriels',
                      style:
                          Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 44,
                            letterSpacing: -1.4,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF171717),
                          ) ??
                          const TextStyle(
                            fontSize: 44,
                            letterSpacing: -1.4,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF171717),
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 52,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final selected = cat == _filtreActif;
                      return GestureDetector(
                        onTap: () => setState(() => _filtreActif = cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 52,
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF1D8FF2)
                                : const Color(0xFFEAEAEA),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF3A3A3A),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filtres.isEmpty
                      ? const Center(child: Text('Aucun tutoriel trouvé'))
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          itemCount: filtres.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 18),
                          itemBuilder: (context, index) => _TutorielTile(
                            tutoriel: filtres[index],
                            onTap: () {
                              if (widget.enfantId != null) {
                                context.pushNamed(
                                  AppRoutes.childTutorialDetailName,
                                  extra: (
                                    tutoriel: filtres[index],
                                    enfantId: widget.enfantId!,
                                  ),
                                );
                              } else {
                                context.pushNamed(
                                  AppRoutes.tutorialDetailName,
                                  extra: filtres[index],
                                );
                              }
                            },
                          ),
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erreur: $e')),
        ),
      ),
    );
  }
}

class _TutorielTile extends StatelessWidget {
  final TutorielModel tutoriel;
  final VoidCallback onTap;

  const _TutorielTile({required this.tutoriel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 96,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE7E7E7)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 80,
                height: 80,
                child: tutoriel.urlImage.isNotEmpty
                    ? Image.network(
                        tutoriel.urlImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFEDF7FF),
                          child: const Icon(
                            Icons.image,
                            color: Color(0xFF7DB9E8),
                          ),
                        ),
                      )
                    : Container(
                        color: const Color(0xFFEDF7FF),
                        child: const Icon(
                          Icons.image,
                          color: Color(0xFF7DB9E8),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tutoriel.titre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D1D1D),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${tutoriel.ageMin}-${tutoriel.ageMax} ans',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF595959),
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
