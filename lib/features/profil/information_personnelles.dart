import 'package:eveiloo_enfant/core/provider/auth_provider.dart';
import 'package:eveiloo_enfant/features/profil/modifier_profil_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kBleu = Color(0xFF2F9BFF);

class InformationsPersonnellesPage extends ConsumerWidget {
  const InformationsPersonnellesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utilisateurAsync = ref.watch(utilisateurCourantProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Informations personnelles',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
      body: utilisateurAsync.when(
        data: (utilisateur) {
          if (utilisateur == null) {
            return const Center(child: Text('Aucun utilisateur connecté.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFFD9F7FF),
                    backgroundImage: utilisateur.urlAvatar.isNotEmpty
                        ? NetworkImage(utilisateur.urlAvatar)
                        : null,
                    child: utilisateur.urlAvatar.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.pinkAccent,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 28),

                _ligne('Prénom', utilisateur.prenom),
                _ligne('Nom', utilisateur.nom),
                _ligne('Email', utilisateur.courriel),
                _ligne(
                  'Téléphone',
                  utilisateur.telephone.isEmpty
                      ? 'Non renseigné'
                      : utilisateur.telephone,
                ),
                _ligne(
                  'Rôle',
                  utilisateur.role.name == 'admin'
                      ? 'Administrateur'
                      : 'Parent',
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ModifierProfilPage(),
                        ),
                      );
                      // Le profil vient de utilisateurCourantProvider (stream),
                      // il se met a jour tout seul apres l'ecriture Firestore :
                      // pas besoin de refetch manuel ici.
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kBleu,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Modifier'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Erreur de chargement : $error')),
      ),
    );
  }

  Widget _ligne(String label, String valeur) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black45,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valeur,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFEDEFF2)),
        ],
      ),
    );
  }
}
