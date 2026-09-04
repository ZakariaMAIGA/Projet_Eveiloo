import 'package:eveiloo_enfant/core/constants/app_colors.dart';
import 'package:eveiloo_enfant/models/JouetModel.dart';
import 'package:eveiloo_enfant/models/toy_model.dart';
import 'package:eveiloo_enfant/repository/toy_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/constants/AppFontSize.dart';
import '../../core/constants/AppSpacing.dart';
import '../../models/favoris.dart' as model;
import '../../repository/favoriRepository.dart';
import '../../widgets/favori_toy_row.dart';

/// Écran "Mes Favoris"
class Favoris extends StatefulWidget {
  const Favoris({
    super.key,
    required this.enfantId,
    this.avatarUrl,
    this.onVoirLeJouet,
  });

  final String enfantId;
  final String? avatarUrl;
  final void Function(String jouetId)? onVoirLeJouet;

  @override
  State<Favoris> createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {
  final FavoriRepository _favoriRepository = FavoriRepository();
  final ToyRepository _jouetRepository = ToyRepository();

  static const _filtreTous = 'Tous';
  String _filtreActif = _filtreTous;

  List<String> _dernierIdsDemandes = [];
  Future<List<ToyModel>>? _jouetsFuture;

  Future<List<ToyModel>> _obtenirJouets(List<String> ids) {
    if (ids.isEmpty) return Future.value([]);

    final idsTries = [...ids]..sort();
    if (_jouetsFuture == null || !listEquals(idsTries, _dernierIdsDemandes)) {
      _dernierIdsDemandes = idsTries;
      _jouetsFuture = _jouetRepository.getJouetsParIds(ids);
    }
    return _jouetsFuture!;
  }

  Future<void> _retirerDesFavoris(String id) {
    return _favoriRepository.supprimer(widget.enfantId, id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _FavorisAppBar(avatarUrl: widget.avatarUrl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _FavorisCategoryChips(
                selected: _filtreActif,
                onSelected: (value) => setState(() => _filtreActif = value),
              ),
            ),
            AppSpacing.verticalGapLg,
            Expanded(
              child: StreamBuilder<List<model.Favoris>>(
                stream: _favoriRepository.observerParEnfant(widget.enfantId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur : ${snapshot.error}'));
                  }

                  final tousLesFavoris = snapshot.data ?? [];

                  final favorisFiltres = tousLesFavoris.where((f) {
                    if (_filtreActif == 'Jouets') return f.type == 'jouet';
                    return true;
                  }).toList();

                  if (favorisFiltres.isEmpty) {
                    return _EtatVide(filtreActif: _filtreActif);
                  }

                  final ids = favorisFiltres.map((f) => f.elementId).toList();

                  return FutureBuilder<List<ToyModel>>(
                    future: _obtenirJouets(ids),
                    builder: (context, jouetsSnapshot) {
                      if (jouetsSnapshot.connectionState ==
                              ConnectionState.waiting &&
                          !jouetsSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (jouetsSnapshot.hasError) {
                        return Center(
                          child: Text('Erreur : ${jouetsSnapshot.error}'),
                        );
                      }

                      final jouetsParId = {
                        for (final jouet in jouetsSnapshot.data ?? [])
                          jouet.id: jouet,
                      };

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          AppSpacing.xl,
                        ),
                        itemCount: favorisFiltres.length,
                        separatorBuilder: (_, __) => AppSpacing.verticalGapXl,
                        itemBuilder: (context, index) {
                          final favori = favorisFiltres[index];
                          final jouet = jouetsParId[favori.elementId];

                          if (jouet == null) {
                            return const SizedBox.shrink();
                          }

                          return FavoriToyRow(
                            jouet: jouet,
                            onVoirLeJouet: () =>
                                widget.onVoirLeJouet?.call(jouet.id),
                            onRetirerDesFavoris: () =>
                                _retirerDesFavoris(favori.elementId),
                          );
                        },
                      );
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
}

class _FavorisAppBar extends StatelessWidget {
  const _FavorisAppBar({this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: Colors.red, size: 30),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF2ECC71),
                  Color(0xFF29B6F6),
                  Color(0xFF7E57C2),
                  Color(0xFFFFA726),
                  Color(0xFFEF5350),
                ],
              ).createShader(bounds),
              child: const Text(
                'Mes Favoris',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSize.large,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.chipBackground,
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : null,
            child: avatarUrl == null
                ? const Icon(Icons.person, color: AppColors.textSecondary)
                : null,
          ),
        ],
      ),
    );
  }
}

class _FavorisCategoryChips extends StatelessWidget {
  const _FavorisCategoryChips({
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  static const _options = [
    (label: 'Tous', value: 'Tous', color: Color(0xFF4DD0E1)),
    (label: '🧸 Jouets', value: 'Jouets', color: Color(0xFFFFB300)),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _options.map((option) {
        final isSelected = option.value == selected;
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: GestureDetector(
            onTap: () => onSelected(option.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: option.color.withValues(alpha: isSelected ? 1 : 0.35),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                option.label,
                style: TextStyle(
                  fontSize: AppFontSize.medium,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _EtatVide extends StatelessWidget {
  const _EtatVide({required this.filtreActif});

  final String filtreActif;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite_border, size: 48, color: Colors.grey),
            AppSpacing.verticalGapMd,
            const Text(
              'Aucun jouet en favoris pour le moment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSize.medium,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
