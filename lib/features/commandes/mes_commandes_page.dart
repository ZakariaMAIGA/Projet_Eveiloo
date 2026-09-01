import 'package:eveiloo_enfant/core/services/auth_service.dart';
import 'package:eveiloo_enfant/repository/CommandeRepository.dart';
import 'package:flutter/material.dart';

import '../../models/commande.dart';
import '../../widgets/commande_card.dart';
import '../../widgets/commande_filter.dart';

class MesCommandesPage extends StatefulWidget {
  const MesCommandesPage({super.key});

  @override
  State<MesCommandesPage> createState() =>
      _MesCommandesPageState();
}

class _MesCommandesPageState
    extends State<MesCommandesPage> {
  String selectedFilter = 'Toutes';

  /// Liste temporaire
  /// Plus tard, elle viendra de Firebase
  // final List<Commande> commandes = [
  //   Commande(
  //     commandeId: '1234',
  //     utilisateurId: 'user1',
  //     adresseLivraison: 'Bamako',
  //     montantTotal: 27000,
  //     statut: 'en_cours',
  //     dateCommande: DateTime(2026, 4, 2),
  //   ),
  //   Commande(
  //     commandeId: '1235',
  //     utilisateurId: 'user1',
  //     adresseLivraison: 'Bamako',
  //     montantTotal: 15000,
  //     statut: 'livree',
  //     dateCommande: DateTime(2026, 4, 2),
  //   ),
  //   Commande(
  //     commandeId: '1237',
  //     utilisateurId: 'user1',
  //     adresseLivraison: 'Bamako',
  //     montantTotal: 27000,
  //     statut: 'annulee',
  //     dateCommande: DateTime(2026, 4, 2),
  //   ),
  //   Commande(
  //     commandeId: '1238',
  //     utilisateurId: 'user1',
  //     adresseLivraison: 'Bamako',
  //     montantTotal: 12000,
  //     statut: 'livree',
  //     dateCommande: DateTime(2026, 4, 2),
  //   ),
  // ];


  List<Commande> getfilteredCommandes({
    required List<Commande> commandes,
  }) {
    if (selectedFilter == 'Toutes') {
      return commandes;
    }

    if (selectedFilter == 'En cours') {
      return commandes
          .where((commande) =>
              commande.statut == 'en_cours')
          .toList();
    }

    if (selectedFilter == 'Livrée') {
      return commandes
          .where((commande) =>
              commande.statut == 'livree')
          .toList();
    }

    if (selectedFilter == 'Annuler') {
      return commandes
          .where((commande) =>
              commande.statut == 'annulee')
          .toList();
    }

    return commandes;
  }

  

  
  @override
  Widget build(BuildContext context) {
    final parentId = AuthService().utilisateurFirebase?.uid ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      body: StreamBuilder<List<Commande>>(
        stream: CommandeRepository().getCommandesUtilisateur(parentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Commande> commandes = snapshot.data ?? [];
          List<Commande> filteredCommandes = getfilteredCommandes(commandes:commandes);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),

                  /// TITRE
                  const Text(
                    'Mes Commandes',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// FILTRES
                  CommandeFilter(
                    selectedFilter: selectedFilter,
                    onSelected: (filter) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                  ),

                  const SizedBox(height: 35),

                  /// LISTE DES COMMANDES
                  Expanded(
                    child: filteredCommandes.isEmpty
                        ? const Center(
                            child: Text(
                              'Aucune commande trouvée',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                filteredCommandes.length,
                            itemBuilder: (context, index) {
                              final commande =
                                  filteredCommandes[index];

                              return CommandeCard(
                                commande: commande,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        }
      )
    );
  }
}