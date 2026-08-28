import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/enfant.dart';
import '../../models/journal_progres_model.dart';
import '../../repository/enfant_repository.dart';
import '../../repository/journal_progres_repository.dart';
import '../../routes/app_route.dart';
import '../activities/activity_service.dart';

class ChildrenProfil extends StatefulWidget {
  final String utilisateurId;
  final String enfantId;

  const ChildrenProfil({
    super.key,
    required this.utilisateurId,
    required this.enfantId,
  });

  @override
  State<ChildrenProfil> createState() => _ChildrenProfilState();
}

class _ChildrenProfilState extends State<ChildrenProfil> {
  final EnfantRepository _enfantRepository = EnfantRepository();
  final JournalProgresRepository _journalRepository =
      JournalProgresRepository();
  final ActivityService _activityService = ActivityService();

  // Objectif fixe pour l'instant : 25 activités = niveau complet.
  static const int _objectifPalier = 25;

  String _libelleNiveau(int activitesRealisees) {
    if (activitesRealisees >= 25) return 'Maître de l\'aventure 🌟';
    if (activitesRealisees >= 15) return 'Super Explorateur 🚀';
    if (activitesRealisees >= 5) return 'Apprenti Curieux 🔎';
    return 'Petit Débutant 🌱';
  }

  double _valeurProgression(int activitesRealisees) {
    return (activitesRealisees / _objectifPalier).clamp(0.0, 1.0);
  }

  String _descriptionEntree(
    JournalProgresModel entree,
    String prenom,
  ) {
    return entree.typeElement == TypeElementProgres.tutoriel
        ? '$prenom a regardé un tutoriel captivant'
        : '$prenom a complété une activité avec succès';
  }

  String _tempsEcoule(DateTime? date) {
    if (date == null) return '';

    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) {
      return 'À l\'instant';
    }

    if (diff.inMinutes < 60) {
      return 'Il y a ${diff.inMinutes} min';
    }

    if (diff.inHours < 24) {
      final h = diff.inHours;
      return 'Il y a $h ${h > 1 ? 'heures' : 'heure'}';
    }

    final j = diff.inDays;
    return 'Il y a $j ${j > 1 ? 'jours' : 'jour'}';
  }

  Future<void> _ouvrirEntreeJournal(
    JournalProgresModel entree,
  ) async {
    if (entree.typeElement == TypeElementProgres.tutoriel) {
      if (!mounted) return;

      context.go(AppRoutes.tutorials);
      return;
    }

    final activite = await _activityService.getActivity(
      entree.elementId,
    );

    if (activite == null || !mounted) return;

    context.go(
      AppRoutes.childActivityDetail,
      extra: activite,
    );
  }

  void _voirToutHistorique() {
    // TODO : brancher vers une vraie page d'historique complet
    // quand elle existera.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Historique complet — bientôt disponible ! ✨',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF29258F),
              size: 20,
            ),
          ),

          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),

        title: const Text(
          'Profil',
          style: TextStyle(
            color: Color(0xFF29258F),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<EnfantModel?>(
        stream: _enfantRepository.observerEnfant(
          widget.utilisateurId,
          widget.enfantId,
        ),

        builder: (context, snapshotEnfants) {
          if (snapshotEnfants.hasError) {
            return const Center(
              child: Text(
                'Une erreur est survenue.',
              ),
            );
          }

          if (!snapshotEnfants.hasData &&
              snapshotEnfants.connectionState ==
                  ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF29258F),
              ),
            );
          }

          final enfant = snapshotEnfants.data;

          if (enfant == null) {
            return const Center(
              child: Text(
                'Enfant introuvable.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              bottom: 40,
              top: 10,
            ),

            child: Column(
              children: [
                _EnteteProfil(
                  nomEnfant: enfant.prenom,
                  urlAvatar: enfant.urlAvatar,
                ),

                const SizedBox(height: 24),

                _BarreProgression(
                  niveau: _libelleNiveau(
                    enfant.activitesRealisees,
                  ),
                  numeroNiveau: enfant.niveauAtteint,
                  valeur: _valeurProgression(
                    enfant.activitesRealisees,
                  ),
                  activitesRealisees:
                      enfant.activitesRealisees,
                  objectif: _objectifPalier,
                ),

                const SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [
                      const _SectionTitle(
                        title: 'Activités Récentes ✨',
                      ),

                      GestureDetector(
                        onTap: _voirToutHistorique,

                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Voir tout',
                              style: TextStyle(
                                color: Color(0xFF6C63FF),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),

                            Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF6C63FF),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                StreamBuilder<List<JournalProgresModel>>(
                  stream: _journalRepository.observerActivitesRecentes(
                    [widget.enfantId],
                    limite: 3,
                  ),

                  builder: (context, snapshotJournal) {
                    if (snapshotJournal.hasError) {
                      return const SizedBox.shrink();
                    }

                    if (!snapshotJournal.hasData) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: CircularProgressIndicator(
                          color: Color(0xFF29258F),
                        ),
                      );
                    }

                    final entrees = snapshotJournal.data!;

                    if (entrees.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),

                        child: Text(
                          'Aucune aventure pour le moment, c\'est l\'heure de jouer !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                      child: Column(
                        children: entrees.map((entree) {
                          return _ActivityCardPremium(
                            urlAvatar: enfant.urlAvatar,
                            titre: entree.titre,
                            description: _descriptionEntree(
                              entree,
                              enfant.prenom,
                            ),
                            tempsEcoule:
                                _tempsEcoule(
                              entree.dateRealisation,
                            ),
                            onTap: () =>
                                _ouvrirEntreeJournal(entree),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                const _GrilleActionsPremium(),
              ],
            ),
          );
        },
      ),
    );
  }
}


// ============================================================
// TITRE DE SECTION
// ============================================================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF29258F),
        letterSpacing: 0.3,
      ),
    );
  }
}


// ============================================================
// ENTÊTE DU PROFIL
// ============================================================

class _EnteteProfil extends StatelessWidget {
  final String nomEnfant;
  final String urlAvatar;

  const _EnteteProfil({
    required this.nomEnfant,
    required this.urlAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8F9BBA)
                .withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),

      // Le badge "Mode parent" a été supprimé.
      child: SizedBox(
        width: double.infinity,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Container(
              padding: const EdgeInsets.all(4),

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF9A9E),
                    Color(0xFFFECFEF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF9A9E)
                        .withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,

                child: CircleAvatar(
                  radius: 46,
                  backgroundColor:
                      const Color(0xFFF0F4FC),

                  backgroundImage:
                      urlAvatar.isNotEmpty
                          ? NetworkImage(urlAvatar)
                          : null,

                  child: urlAvatar.isEmpty
                      ? const Icon(
                          Icons
                              .face_retouching_natural_rounded,
                          size: 45,
                          color: Color(0xFF6C63FF),
                        )
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Salut, $nomEnfant !',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1E2C),
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F5),
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: const Text(
                'Prêt(e) pour une nouvelle aventure ?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE81E63),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================
// BARRE DE PROGRESSION
// ============================================================

class _BarreProgression extends StatelessWidget {
  final String niveau;
  final int numeroNiveau;
  final double valeur;
  final int activitesRealisees;
  final int objectif;

  const _BarreProgression({
    required this.niveau,
    required this.numeroNiveau,
    required this.valeur,
    required this.activitesRealisees,
    required this.objectif,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4FACFE),
            Color(0xFF00F2FE),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F2FE)
                .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFD166),
                      Color(0xFFFFA751),
                    ],
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFA751)
                          .withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.military_tech_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      niveau,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Niveau $numeroNiveau',
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 12,

                      decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(0.25),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),

                    FractionallySizedBox(
                      widthFactor: valeur,

                      child: Container(
                        height: 12,

                        decoration: BoxDecoration(
                          gradient:
                              const LinearGradient(
                            colors: [
                              Color(0xFFFFD166),
                              Color(0xFFFFA751),
                            ],
                          ),

                          borderRadius:
                              BorderRadius.circular(10),

                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFFFFA751)
                                      .withOpacity(0.7),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(14),
                ),

                child: Text(
                  '${(valeur * 100).round()}%',
                  style: const TextStyle(
                    color: Color(0xFF29258F),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            '$activitesRealisees / $objectif activités réalisées',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// CARTE ACTIVITÉ
// ============================================================

class _ActivityCardPremium extends StatefulWidget {
  final String urlAvatar;
  final String titre;
  final String description;
  final String tempsEcoule;
  final VoidCallback onTap;

  const _ActivityCardPremium({
    required this.urlAvatar,
    required this.titre,
    required this.description,
    required this.tempsEcoule,
    required this.onTap,
  });

  @override
  State<_ActivityCardPremium> createState() =>
      _ActivityCardPremiumState();
}

class _ActivityCardPremiumState
    extends State<_ActivityCardPremium> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,

      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },

      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },

      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,

        transform: Matrix4.translationValues(
          0,
          _isHovered ? -4 : 0,
          0,
        ),

        margin: const EdgeInsets.only(
          bottom: 14,
        ),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFF6C63FF)
                      .withOpacity(0.30)
                  : const Color(0xFF8F9BBA)
                      .withOpacity(0.08),

              blurRadius:
                  _isHovered ? 28 : 10,

              spreadRadius:
                  _isHovered ? 3 : 0,

              offset: Offset(
                0,
                _isHovered ? 10 : 4,
              ),
            ),
          ],
        ),

        child: Material(
          color: Colors.transparent,
          borderRadius:
              BorderRadius.circular(20),

          child: InkWell(
            borderRadius:
                BorderRadius.circular(20),

            onTap: widget.onTap,

            splashColor:
                const Color(0xFFF0F4FC),

            highlightColor:
                const Color(0xFFF9FAFC),

            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.all(3),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      gradient:
                          const LinearGradient(
                        colors: [
                          Color(0xFFB19CD9),
                          Color(0xFFF6C9FF),
                        ],
                      ),

                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color:
                                    const Color(
                                  0xFFB19CD9,
                                ).withOpacity(0.65),
                                blurRadius: 18,
                                spreadRadius: 3,
                              ),
                            ]
                          : [],
                    ),

                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor:
                          Colors.white,

                      backgroundImage:
                          widget.urlAvatar.isNotEmpty
                              ? NetworkImage(
                                  widget.urlAvatar,
                                )
                              : null,

                      child: widget.urlAvatar.isEmpty
                          ? const Icon(
                              Icons.star_rounded,
                              color:
                                  Colors.purpleAccent,
                              size: 30,
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          widget.titre,

                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,

                            fontSize:
                                _isHovered ? 17 : 16,

                            color:
                                const Color(
                              0xFF1E1E2C,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          widget.description,

                          style: TextStyle(
                            fontSize: 13,
                            color:
                                Colors.grey.shade600,
                            fontWeight:
                                FontWeight.w500,
                          ),

                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                        ),

                        if (widget.tempsEcoule.isNotEmpty) ...[
                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Icon(
                                Icons
                                    .access_time_rounded,
                                size: 13,
                                color:
                                    Colors.grey.shade400,
                              ),

                              const SizedBox(width: 4),

                              Text(
                                widget.tempsEcoule,

                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds: 220,
                    ),

                    padding:
                        const EdgeInsets.all(4),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: _isHovered
                          ? const Color(0xFF6C63FF)
                              .withOpacity(0.12)
                          : const Color(0xFFF0F4FC),

                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color:
                                    const Color(
                                  0xFF6C63FF,
                                ).withOpacity(0.55),
                                blurRadius: 14,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),

                    child: Icon(
                      Icons
                          .chevron_right_rounded,
                      color:
                          const Color(0xFF6C63FF),
                      size:
                          _isHovered ? 31 : 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// ============================================================
// GRILLE DES ACTIONS
// ============================================================

class _GrilleActionsPremium
    extends StatelessWidget {
  const _GrilleActionsPremium();

  static const List<_ActionItemPremium>
      _actions = [
    _ActionItemPremium(
      label: 'Jouets',
      description:
          'Découvrir des jouets amazing !',
      icon:
          Icons.child_friendly_rounded,
      couleur:
          Color(0xFFFF6B81),
      couleurFond:
          Color(0xFFFFF0F3),
      route:
          '/catalogue/toys',
    ),

    _ActionItemPremium(
      label: 'Tutoriels',
      description:
          'Regarder et apprendre chaque jour',
      icon:
          Icons.smart_display_rounded,
      couleur:
          Color(0xFF2D8DD5),
      couleurFond:
          Color(0xFFE8F4FD),
      route:
          '/tutorials',
    ),

    _ActionItemPremium(
      label: 'Mes badges',
      description:
          'Voir mes badges et récompenses',
      icon:
          Icons.emoji_events_rounded,
      couleur:
          Color(0xFFF5A623),
      couleurFond:
          Color(0xFFFFF6E5),
      route: null,
    ),

    _ActionItemPremium(
      label: 'Activités',
      description:
          'Jouer et progresser en s\'amusant',
      icon:
          Icons.extension_rounded,
      couleur:
          Color(0xFF2FA84F),
      couleurFond:
          Color(0xFFEAFAEE),
      route:
          '/activities',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      child: GridView.builder(
        itemCount: _actions.length,
        shrinkWrap: true,

        physics:
            const NeverScrollableScrollPhysics(),

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.95,
        ),

        itemBuilder: (context, index) {
          return _ActionTilePremium(
            item: _actions[index],
          );
        },
      ),
    );
  }
}


// ============================================================
// MODÈLE ACTION
// ============================================================

class _ActionItemPremium {
  final String label;
  final String description;
  final IconData icon;
  final Color couleur;
  final Color couleurFond;
  final String? route;

  const _ActionItemPremium({
    required this.label,
    required this.description,
    required this.icon,
    required this.couleur,
    required this.couleurFond,
    this.route,
  });
}


// ============================================================
// TUile ACTION
// ============================================================

class _ActionTilePremium
    extends StatelessWidget {
  final _ActionItemPremium item;

  const _ActionTilePremium({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: item.couleurFond,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color:
              item.couleur.withOpacity(0.15),
        ),
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius:
              BorderRadius.circular(20),

          onTap: () {
            if (item.route != null) {
              context.go(item.route!);
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    '${item.label} — bientôt disponible ! ✨',
                  ),

                  behavior:
                      SnackBarBehavior.floating,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),

                  backgroundColor:
                      item.couleur,
                ),
              );
            }
          },

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Container(
                width: 46,
                height: 46,

                decoration: BoxDecoration(
                  color: item.couleur,
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  item.icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                item.label,

                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                  color: item.couleur,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                item.description,

                style: TextStyle(
                  fontSize: 12,
                  color:
                      Colors.grey.shade600,
                  fontWeight:
                      FontWeight.w500,
                ),

                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}