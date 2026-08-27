import 'package:eveiloo_enfant/features/profil/widgets/profile_header.dart';
import 'package:eveiloo_enfant/features/profil/widgets/profile_menu.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(
          Icons.arrow_back_ios_new,
          size: 18,
          color: Colors.black,
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          const ProfileHeader(name: 'Utilisateur'),

          const SizedBox(height: 20),

          // Ici ton menu prend tout l’espace restant
          Expanded(child: SingleChildScrollView(child: ProfileMenu())),
        ],
      ),
    );
  }
}
