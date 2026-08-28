import 'package:eveiloo_enfant/core/services/auth_service.dart';
import 'package:eveiloo_enfant/models/enfant.dart';
import 'package:eveiloo_enfant/repository/enfant_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChildrenListPage extends StatelessWidget {
  const ChildrenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final parentId = AuthService().utilisateurFirebase?.uid ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Mes enfants'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),

      body: StreamBuilder<List<EnfantModel>>(
        stream: EnfantRepository().observerEnfants(parentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final enfants = snapshot.data ?? [];

          if (enfants.isEmpty) {
            return const Center(
              child: Text('Aucun enfant ajouté pour le moment.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: enfants.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final enfant = enfants[index];

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    leading: CircleAvatar(
                      backgroundImage: enfant.urlAvatar.isNotEmpty
                          ? NetworkImage(enfant.urlAvatar)
                          : null,
                      child: enfant.urlAvatar.isEmpty
                          ? const Icon(Icons.face)
                          : null,
                    ),
                    title: Text(
                      enfant.prenom,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${enfant.age} ans · Niveau ${enfant.niveauAtteint} · ${enfant.pointsGagnes} pts',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.go('/childProfil/$parentId/${enfant.enfantId}');
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: ouvrir le formulaire d'ajout d'enfant
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
