import 'package:eveiloo_enfant/core/provider/enfant_provider.dart';
import 'package:eveiloo_enfant/core/provider/enfant_selectionne_provider.dart';
import 'package:eveiloo_enfant/models/enfant.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MesEnfantsPage extends ConsumerWidget {
  const MesEnfantsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enfantsAsync = ref.watch(mesEnfantsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.goNamed(AppRoutes.profileName),
                    icon: const Icon(Icons.arrow_back, size: 32),
                  ),
                  const Text(
                    'Mes Enfants',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  FloatingActionButton(
                    onPressed: () => context.go(AppRoutes.childrenAdd),
                    mini: true,
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Expanded(
                child: enfantsAsync.when(
                  data: (enfants) {
                    if (enfants.isEmpty) {
                      return const _AucunEnfant();
                    }

                    return ListView.separated(
                      itemCount: enfants.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        final enfant = enfants[index];
                        return _CarteEnfant(enfant: enfant);
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Erreur lors du chargement des enfants :\n$error',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Carte enfant
// ---------------------------------------------------------------------------
class _CarteEnfant extends ConsumerWidget {
  final EnfantModel enfant;

  const _CarteEnfant({required this.enfant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        leading: _buildAvatar(enfant),
        title: Text(
          enfant.prenom,
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(_calculerAge(enfant.dateNaissance)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          ref.read(enfantSelectionneProvider.notifier).state = enfant.enfantId;
          context.goNamed(AppRoutes.childHomeName);
        },
      ),
    );
  }

  Widget _buildAvatar(EnfantModel enfant) {
    if (enfant.urlAvatar.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          enfant.urlAvatar,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _avatarParDefaut(),
        ),
      );
    }
    return _avatarParDefaut();
  }

  Widget _avatarParDefaut() {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: const Icon(Icons.child_care, color: Colors.white, size: 30),
    );
  }
}

// ---------------------------------------------------------------------------
// État vide
// ---------------------------------------------------------------------------
class _AucunEnfant extends StatelessWidget {
  const _AucunEnfant();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.child_care, size: 70, color: Colors.grey),
          const SizedBox(height: 15),
          const Text(
            'Aucun enfant enregistré',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.go(AppRoutes.childrenAdd),
            icon: const Icon(Icons.add),
            label: const Text('Ajouter un enfant'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Calcul de l'âge
// ---------------------------------------------------------------------------
String _calculerAge(String dateNaissance) {
  if (dateNaissance.isEmpty) return 'Âge non renseigné';

  try {
    final parties = dateNaissance.split('/');
    if (parties.length != 3) return 'Âge non renseigné';

    final jour = int.parse(parties[0]);
    final mois = int.parse(parties[1]);
    final annee = int.parse(parties[2]);

    final naissance = DateTime(annee, mois, jour);
    final maintenant = DateTime.now();

    int age = maintenant.year - naissance.year;

    if (maintenant.month < naissance.month ||
        (maintenant.month == naissance.month &&
            maintenant.day < naissance.day)) {
      age--;
    }

    if (age < 0) return 'Âge non renseigné';
    if (age == 0) return 'Moins d’un an';
    if (age == 1) return '1 an';
    return '$age ans';
  } catch (_) {
    return 'Âge non renseigné';
  }
}
