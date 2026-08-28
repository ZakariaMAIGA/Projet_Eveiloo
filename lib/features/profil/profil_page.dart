import 'package:eveiloo_enfant/core/provider/auth_provider.dart';
import 'package:eveiloo_enfant/features/profil/widgets/profile_header.dart';
import 'package:eveiloo_enfant/features/profil/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilPage extends ConsumerWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utilisateurAsync = ref.watch(utilisateurCourantProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),

      body: utilisateurAsync.when(
        data: (utilisateur) {
          final nomComplet = utilisateur == null
              ? 'Utilisateur'
              : '${utilisateur.prenom} ${utilisateur.nom}'.trim();

          return Column(
            children: [
              const SizedBox(height: 10),

              ProfileHeader(
                name: nomComplet.isEmpty ? 'Utilisateur' : nomComplet,
                photoUrl: utilisateur?.urlAvatar,
              ),

              const SizedBox(height: 20),

              // Ici ton menu prend tout l'espace restant
              const Expanded(
                child: SingleChildScrollView(child: ProfileMenu()),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Erreur de chargement du profil : $error')),
      ),
    );
  }
}
