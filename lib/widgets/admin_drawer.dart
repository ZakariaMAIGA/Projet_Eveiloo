import 'package:eveiloo_enfant/core/constants/admin_ui.dart';
import 'package:flutter/material.dart';

/// Un item du menu admin. [route] doit correspondre à la route GoRouter
/// enregistrée dans app_router.dart (adapte les chemins à ton routeur).
class AdminMenuItem {
  const AdminMenuItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}

const List<AdminMenuItem> adminMenuItems = [
  AdminMenuItem(
    icon: Icons.grid_view_rounded,
    label: 'Tableau de bord',
    route: '/admin',
  ),
  AdminMenuItem(
    icon: Icons.people_alt_outlined,
    label: 'Utilisateurs',
    route: '/admin/utilisateurs',
  ),
  AdminMenuItem(
    icon: Icons.child_care_outlined,
    label: 'Enfants',
    route: '/admin/enfants',
  ),
  AdminMenuItem(
    icon: Icons.smart_toy_outlined,
    label: 'Jouets',
    route: '/admin/jouets',
  ),
  AdminMenuItem(
    icon: Icons.checklist_rtl_outlined,
    label: 'Activités',
    route: '/admin/activites',
  ),
  AdminMenuItem(
    icon: Icons.smart_display_outlined,
    label: 'Tutoriels',
    route: '/admin/tutoriels',
  ),
  AdminMenuItem(
    icon: Icons.shopping_bag_outlined,
    label: 'Commandes',
    route: '/admin/commandes',
  ),
  AdminMenuItem(
    icon: Icons.payments_outlined,
    label: 'Payements',
    route: '/admin/payements',
  ),
  AdminMenuItem(
    icon: Icons.bar_chart_rounded,
    label: 'Rapports',
    route: '/admin/rapports',
  ),
];

/// Menu admin en overlay (Drawer natif Flutter : glisse déjà par-dessus la
/// page, exactement comme demandé). Utilisé via `AdminScaffold`.
class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key, required this.currentRoute, this.onNavigate});

  final String currentRoute;
  final void Function(String route)? onNavigate;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            _buildLogo(),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: adminMenuItems.length,
                itemBuilder: (context, index) {
                  final item = adminMenuItems[index];
                  final isActive = item.route == currentRoute;
                  return _AdminDrawerTile(
                    item: item,
                    isActive: isActive,
                    onTap: () {
                      Navigator.of(context).pop(); // ferme l'overlay
                      onNavigate?.call(item.route);
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

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AdminColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: AdminColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Eveiloo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AdminColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminDrawerTile extends StatelessWidget {
  const _AdminDrawerTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final AdminMenuItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isActive
            ? AdminColors.primary.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: isActive ? AdminColors.primary : AdminColors.textMuted,
                ),
                const SizedBox(width: 14),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? AdminColors.primary
                        : AdminColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
