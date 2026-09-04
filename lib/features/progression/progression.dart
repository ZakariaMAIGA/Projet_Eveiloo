import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/provider/enfant_provider.dart';
import '../../core/provider/journal_progres_provider.dart';
import '../../models/journal_progres_model.dart';
import '../children/children_profil.dart'; // enfantParIdProvider

class ProgressionPage extends ConsumerStatefulWidget {
  final String enfantId;

  const ProgressionPage({super.key, required this.enfantId});

  @override
  ConsumerState<ProgressionPage> createState() => _ProgressionPageState();
}

class _ProgressionPageState extends ConsumerState<ProgressionPage> {
  String _periodeSelectionnee = 'Cette semaine';

  DateTime _dateLimite() {
    final maintenant = DateTime.now();
    switch (_periodeSelectionnee) {
      case 'Ce mois':
        return DateTime(maintenant.year, maintenant.month - 1, maintenant.day);
      case 'Cette année':
        return DateTime(maintenant.year - 1, maintenant.month, maintenant.day);
      case 'Cette semaine':
      default:
        return maintenant.subtract(const Duration(days: 7));
    }
  }

  String _formaterDuree(int totalSecondes) {
    final h = totalSecondes ~/ 3600;
    final m = (totalSecondes % 3600) ~/ 60;
    if (h == 0) return '${m}m';
    return '${h}h${m.toString().padLeft(2, '0')}m';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final entreesAsync = ref.watch(
      journalProgresEntreesEnfantProvider(widget.enfantId),
    );
    final enfantAsync = ref.watch(enfantParIdProvider(widget.enfantId));

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color(0xFF0D0E52),
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre "Progression" + prénom de l'enfant
              enfantAsync.when(
                data: (enfant) => Text(
                  enfant != null
                      ? 'Progression de ${enfant.prenom}'
                      : 'Progression',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0D0E52),
                  ),
                ),
                loading: () => Text(
                  'Progression',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0D0E52),
                  ),
                ),
                error: (_, __) => Text(
                  'Progression',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0D0E52),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bouton déroulant période
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                    width: 1.2,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _periodeSelectionnee,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isDark ? Colors.white : Colors.black87,
                      size: 28,
                    ),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    isExpanded: true,
                    dropdownColor: isDark
                        ? const Color(0xFF1E1E1E)
                        : Colors.white,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => _periodeSelectionnee = newValue);
                      }
                    },
                    items: <String>['Cette semaine', 'Ce mois', 'Cette année']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              entreesAsync.when(
                data: (entrees) {
                  final dateLimite = _dateLimite();
                  final filtrees = entrees
                      .where(
                        (e) =>
                            e.dateRealisation != null &&
                            e.dateRealisation!.isAfter(dateLimite),
                      )
                      .toList();

                  final activites = filtrees
                      .where(
                        (e) => e.typeElement == TypeElementProgres.activite,
                      )
                      .toList();

                  final activitesCompletees = activites.length;

                  final tempsTotalSecondes = filtrees.fold<int>(
                    0,
                    (somme, e) => somme + e.dureeSecondes,
                  );

                  final resultatMoyenne = activites.isEmpty
                      ? 0.0
                      : activites.map((e) => e.score).reduce((a, b) => a + b) /
                            activites.length;

                  return Column(
                    children: [
                      _buildStatCard(
                        isDark: isDark,
                        bgColor: isDark
                            ? const Color(0xFF2C1E24)
                            : const Color(0xFFFFF0F5),
                        borderColor: isDark
                            ? Colors.pink.shade900
                            : const Color(0xFFFFD6E7),
                        icon: Icons.local_fire_department_rounded,
                        iconBgColor: isDark
                            ? Colors.pink.shade900.withOpacity(0.5)
                            : const Color(0xFFFFE3EE),
                        iconColor: const Color(0xFFFF80AB),
                        title: 'Activités complétées',
                        value: '$activitesCompletees',
                      ),
                      const SizedBox(height: 16),
                      _buildStatCard(
                        isDark: isDark,
                        bgColor: isDark
                            ? const Color(0xFF1A2634)
                            : const Color(0xFFF0F7FF),
                        borderColor: isDark
                            ? Colors.blue.shade900
                            : const Color(0xFFD0E8FF),
                        icon: Icons.timer_outlined,
                        iconBgColor: isDark
                            ? Colors.blue.shade900.withOpacity(0.5)
                            : const Color(0xFFD6EBFF),
                        iconColor: const Color(0xFF29B6F6),
                        title: 'Temps d\'apprentissage',
                        value: _formaterDuree(tempsTotalSecondes),
                      ),
                      const SizedBox(height: 16),
                      _buildStatCard(
                        isDark: isDark,
                        bgColor: isDark
                            ? const Color(0xFF1E2638)
                            : const Color(0xFFF3F6FF),
                        borderColor: isDark
                            ? Colors.indigo.shade400
                            : const Color(0xFF7C4DFF),
                        borderWidth: 2.0,
                        icon: Icons.water_drop_outlined,
                        iconBgColor: isDark
                            ? Colors.lightBlue.shade900.withOpacity(0.5)
                            : const Color(0xFFE1F5FE),
                        iconColor: const Color(0xFF00E676),
                        title: 'Résultat moyen',
                        value: '${resultatMoyenne.round()}%',
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Image.asset(
                              'assets/images/bears_encouragement.png',
                              height: 130,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.emoji_emotions_outlined,
                                    size: 90,
                                    color: Colors.amber,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 6,
                            child: Text(
                              activitesCompletees > 0
                                  ? 'Youpi, vous faites de très beaux progrès !'
                                  : 'Aucune activité sur cette période — c\'est le moment de jouer !',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text('Erreur: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required bool isDark,
    required Color bgColor,
    required Color borderColor,
    double borderWidth = 1.0,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
