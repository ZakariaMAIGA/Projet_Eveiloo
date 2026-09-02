import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/AppSpacing.dart';
import '../../models/Commande.dart';
import '../../repository/commande_repository.dart';

class CommandesPage extends StatelessWidget {
  const CommandesPage({Key? key}) : super(key: key);
  static final CommandeRepository _repository = CommandeRepository();

  Color _statutColor(StatutCommande statut) {
    switch (statut) {
      case StatutCommande.livree:
        return Colors.green;
      case StatutCommande.expediee:
        return Colors.blue;
      case StatutCommande.confirmee:
        return Colors.orange;
      case StatutCommande.annulee:
        return Colors.red;
      case StatutCommande.enAttente:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mes commandes')),
        body: const Center(child: Text('Veuillez vous connecter.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mes commandes')),
      body: StreamBuilder<List<Commande>>(
        stream: _repository.streamCommandes(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint('Erreur streamCommandes: ${snapshot.error}');
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Erreur : ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final commandes = snapshot.data ?? [];
          if (commandes.isEmpty) {
            return const Center(child: Text('Aucune commande pour le moment.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: commandes.length,
            itemBuilder: (context, index) {
              final commande = commandes[index];
              return Card(
                child: ListTile(
                  title: Text(
                    'Commande #${commande.commandeId.substring(0, 6)}',
                  ),
                  subtitle: Text(commande.dateCommande?.toString() ?? ''),
                  trailing: Chip(
                    label: Text(commande.statut.name),
                    backgroundColor: _statutColor(
                      commande.statut,
                    ).withOpacity(0.15),
                    labelStyle: TextStyle(color: _statutColor(commande.statut)),
                  ),
                  onTap: () =>
                      context.push('/commandes/${commande.commandeId}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
