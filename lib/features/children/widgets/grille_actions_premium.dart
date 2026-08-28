import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GrilleActionsPremium extends StatelessWidget {
  const GrilleActionsPremium({super.key});

  static const List<_ActionItemPremium> _actions = [
    _ActionItemPremium(
      label: 'Jouets',
      description: 'Découvrir des jouets amazing !',
      icon: Icons.child_friendly_rounded,
      couleur: Color(0xFFFF6B81),
      couleurFond: Color(0xFFFFF0F3),
      route: '/catalogue/toys',
    ),
    _ActionItemPremium(
      label: 'Tutoriels',
      description: 'Regarder et apprendre chaque jour',
      icon: Icons.smart_display_rounded,
      couleur: Color(0xFF2D8DD5),
      couleurFond: Color(0xFFE8F4FD),
      route: '/tutorials',
    ),
    _ActionItemPremium(
      label: 'Mes badges',
      description: 'Voir mes badges et récompenses',
      icon: Icons.emoji_events_rounded,
      couleur: Color(0xFFF5A623),
      couleurFond: Color(0xFFFFF6E5),
      route: null,
    ),
    _ActionItemPremium(
      label: 'Activités',
      description: 'Jouer et progresser en s\'amusant',
      icon: Icons.extension_rounded,
      couleur: Color(0xFF2FA84F),
      couleurFond: Color(0xFFEAFAEE),
      route: '/activities',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        itemCount: _actions.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.95,
        ),
        itemBuilder: (context, index) {
          return _ActionTilePremium(item: _actions[index]);
        },
      ),
    );
  }
}

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

class _ActionTilePremium extends StatelessWidget {
  final _ActionItemPremium item;

  const _ActionTilePremium({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.couleurFond,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: item.couleur.withOpacity(0.15)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (item.route != null) {
              context.go(item.route!);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.label} — bientôt disponible ! ✨'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: item.couleur,
                ),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: item.couleur,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: item.couleur,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
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
