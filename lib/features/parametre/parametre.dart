import 'package:eveiloo_enfant/core/provider/parametreProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eveiloo_enfant/core/provider/parametreProvider.dart';

class ParametresPage extends ConsumerWidget {
  const ParametresPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeTheme = ref.watch(themeProvider);
    final localeLangue = ref.watch(langueProvider);
    final notificationsActives = ref.watch(notificationProvider);

    final estSombre = modeTheme == ThemeMode.dark;
    final codeLangue = localeLangue.languageCode;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Header avec Titre et bouton de fermeture
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Paramètres',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 20),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 1. Notifications Switch
              _buildCardTile(
                context: context,
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                trailing: Switch(
                  value: notificationsActives,
                  activeColor: const Color(0xFF29B6F6),
                  onChanged: (val) {
                    ref.read(notificationProvider.notifier).basculerNotification(val);
                  },
                ),
              ),

              // 2. Informations personnelles
              _buildCardTile(
                context: context,
                icon: Icons.badge_outlined,
                title: 'Informations personnelle',
                onTap: () {},
              ),

              // 3. Langue
              _buildCardTile(
                context: context,
                icon: Icons.translate_rounded,
                title: 'Langue',
                valueText: codeLangue == 'fr' ? 'Français' : 'English',
                onTap: () => _afficherDialogueLangue(context, ref, codeLangue),
              ),

              // 4. Thème (Bascule dynamique)
              _buildCardTile(
                context: context,
                icon: Icons.wb_sunny_outlined,
                title: 'Thème',
                valueText: estSombre ? 'Sombre' : 'Clair',
                onTap: () {
                  ref.read(themeProvider.notifier).basculerTheme(!estSombre);
                },
              ),

              // 5. À propos
              _buildCardTile(
                context: context,
                icon: Icons.info_outline_rounded,
                title: 'A propos de l\'application',
                onTap: () {},
              ),

              // 6. Conditions d'utilisation
              _buildCardTile(
                context: context,
                icon: Icons.description_outlined,
                title: 'Conditions d\'utilisation',
                onTap: () {},
              ),

              const SizedBox(height: 32),

              // Version
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Composant Carte
  Widget _buildCardTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? valueText,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, size: 26),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: trailing ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (valueText != null) ...[
                  Text(
                    valueText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              ],
            ),
        onTap: onTap,
      ),
    );
  }

  // Pop-up Sélection Langue
  void _afficherDialogueLangue(BuildContext context, WidgetRef ref, String langueActuelle) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choisir la langue'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Français'),
                value: 'fr',
                groupValue: langueActuelle,
                onChanged: (val) {
                  if (val != null) {
                    ref.read(langueProvider.notifier).changerLangue(val);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('English'),
                value: 'en',
                groupValue: langueActuelle,
                onChanged: (val) {
                  if (val != null) {
                    ref.read(langueProvider.notifier).changerLangue(val);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}