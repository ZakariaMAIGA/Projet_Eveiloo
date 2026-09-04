import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GrilleActionsPremium extends StatelessWidget {
  final String enfantId;

  const GrilleActionsPremium({super.key, required this.enfantId});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItemPremium(
        label: 'Activités',
        description: 'Jouer et progresser en s\'amusant',
        icon: Icons.extension_rounded,
        couleur: const Color(0xFF2FA84F),
        couleurFond: const Color(0xFFEAFAEE),
        onTap: () => StatefulNavigationShell.of(
          context,
        ).goBranch(1), // branche Activités du shell enfant
      ),
      _ActionItemPremium(
        label: 'Tutoriels',
        description: 'Regarder et apprendre chaque jour',
        icon: Icons.smart_display_rounded,
        couleur: const Color(0xFF2D8DD5),
        couleurFond: const Color(0xFFE8F4FD),
        onTap: () => StatefulNavigationShell.of(
          context,
        ).goBranch(2), // branche Tutoriels du shell enfant
      ),
      _ActionItemPremium(
        label: 'Catalogue',
        description: 'Découvrir des jouets et les ajouter en favoris',
        icon: Icons.storefront_rounded,
        couleur: const Color(0xFFE9168C),
        couleurFond: const Color(0xFFFFE9F5),
        onTap: () => context.pushNamed(
          AppRoutes.childCatalogueName,
          queryParameters: {'enfantId': enfantId},
        ),
      ),
      _ActionItemPremium(
        label: 'Mes badges',
        description: 'Voir mes badges et récompenses',
        icon: Icons.emoji_events_rounded,
        couleur: const Color(0xFFF5A623),
        couleurFond: const Color(0xFFFFF6E5),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mes badges — bientôt disponible ! ✨'),
            behavior: SnackBarBehavior.floating,
          ),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        itemCount: actions.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.95,
        ),
        itemBuilder: (context, index) =>
            _ActionTilePremium(item: actions[index]),
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
  final VoidCallback onTap;

  const _ActionItemPremium({
    required this.label,
    required this.description,
    required this.icon,
    required this.couleur,
    required this.couleurFond,
    required this.onTap,
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
          onTap: item.onTap,
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
