import 'package:eveiloo_enfant/core/constants/AppColors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import '../../core/constants/AppColors.dart';
import '../../core/constants/AppFontSize.dart';
import '../../core/constants/AppSpacing.dart';
import '../../models/favoris.dart';
import '../../models/jouetModel.dart';
import '../../repository/favoriRepository.dart';
// import '../../repository/jouetRepository.dart';
// import '../../widgets/favori_toy_row.dart';

/// Écran "Mes Favoris" : liste des jouets qu'un enfant a mis en favori,
/// avec filtre par catégorie (Tous / Jouets).
class FavorisScreen extends StatefulWidget {
  const FavorisScreen({
    super.key,
    required this.enfantId,
    this.avatarUrl,
    this.onVoirLeJouet,
  });

  /// Id de l'enfant dont on affiche les favoris.
  final String enfantId;

  /// URL de l'avatar affiché en haut à droite (avatar de l'enfant).
  final String? avatarUrl;

  /// Appelé avec le [JouetModel.jouetId] quand on tape "Voir le jouet".
  final void Function(String jouetId)? onVoirLeJouet;

  @override
  State<FavorisScreen> createState() => _FavorisScreenState();
}

class _FavorisScreenState extends State<FavorisScreen> {
  final FavoriRepository _favoriRepository = FavoriRepository();
  // final JouetRepository _jouetRepository = JouetRepository();

  static const _filtreTous = 'Tous';
  static const _filtreJouets = 'Jouets';

  String _filtreActif = _filtreTous;

  List<String> _dernierIdsDemandes = [];
  Future<List<JouetModel>>? _jouetsFuture;

  /// Récupère les jouets correspondant à [ids], en mémorisant la requête
  /// tant que la liste d'ids ne change pas (évite de refetch à chaque build).
  Future<List<JouetModel>> _obtenirJouets(List<String> ids) {
    final idsTries = [...ids]..sort();
    if (_jouetsFuture == null || !listEquals(idsTries, _dernierIdsDemandes)) {
      _dernierIdsDemandes = idsTries;
      // _jouetsFuture = _jouetRepository.obtenirParIds(ids);
    }
    return _jouetsFuture!;
  }

  Future<void> _retirerDesFavoris(String favoriId) {
    return _favoriRepository.supprimer(favoriId);
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
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black87,
                    ),
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
              child: StreamBuilder<List<Favoris>>(
                stream: _favoriRepository.observerParEnfant(widget.enfantId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Erreur : ${snapshot.error}'),
                    );
                  }

                  final tousLesFavoris = snapshot.data ?? [];

                  // NOTE : seul le type "jouet" a un rendu implémenté pour
                  // l'instant (aucune maquette pour les favoris d'activités/
                  // tutoriels). Donc "Tous" et "🧸 Jouets" affichent le même
                  // résultat aujourd'hui. Le filtre reste posé pour être
                  // câblé dès qu'un autre type aura son propre design.
                  final favorisJouets =
                      tousLesFavoris.where((f) => f.type == 'jouet').toList();

                  if (favorisJouets.isEmpty) {
                    return _EtatVide(filtreActif: _filtreActif);
                  }

                  final ids =
                      favorisJouets.map((f) => f.elementId).toList();

                  return FutureBuilder<List<JouetModel>>(
                    future: _obtenirJouets(ids),
                    builder: (context, jouetsSnapshot) {
                      if (jouetsSnapshot.connectionState ==
                              ConnectionState.waiting &&
                          !jouetsSnapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (jouetsSnapshot.hasError) {
                        return Center(
                          child: Text('Erreur : ${jouetsSnapshot.error}'),
                        );
                      }

                      final jouetsParId = {
                        for (final jouet in jouetsSnapshot.data ?? [])
                          jouet.jouetId: jouet,
                      };

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          AppSpacing.xl,
                        ),
                        itemCount: favorisJouets.length,
                        separatorBuilder: (_, __) =>
                            AppSpacing.verticalGapXl,
                        itemBuilder: (context, index) {
                          final favori = favorisJouets[index];
                          final jouet = jouetsParId[favori.elementId];

                          if (jouet == null) {
                            // Le jouet référencé n'existe plus / pas encore chargé.
                            return const SizedBox.shrink();
                          }

                          // return FavoriToyRow(
                          //   jouet: jouet,
                          //   onVoirLeJouet: () =>
                          //       widget.onVoirLeJouet?.call(jouet.jouetId),
                          //   onRetirerDesFavoris: () =>
                          //       _retirerDesFavoris(favori.id),
                          // );
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

/// Barre du haut : cœur décoratif, titre multicolore "Mes Favoris", avatar.
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
          SizedBox(width: AppSpacing.md),
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.chipBackground,
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? const Icon(Icons.person, color: AppColors.textSecondary)
          ),
            backgroundColor: Color(0xFFE0E0E0),
        ],
      ),
    );
  }
}
/// Chips de filtre par catégorie ("Tous" / "🧸 Jouets").
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
            const Icon(
              Icons.favorite_border,
              size: 48,
              color: Colors.grey,
            ),
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
