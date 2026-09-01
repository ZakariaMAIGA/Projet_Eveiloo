import 'package:eveiloo_enfant/provider/CommandeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/auth_service.dart';
 
import '../../widgets/commande_card.dart';
import '../../widgets/commande_filter.dart';

class MesCommandesPage extends StatefulWidget {
  const MesCommandesPage({super.key});

  @override
  State<MesCommandesPage> createState() => _MesCommandesPageState();
}

class _MesCommandesPageState extends State<MesCommandesPage> {
  @override
  void initState() {
    super.initState();
    // Initialisation de l'écoute des commandes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parentId = AuthService().utilisateurFirebase?.uid ?? '';
      context.read<CommandeProvider>().ecouterCommandes(parentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Mes Commandes',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 35),

              // Sélecteur de filtre
              Consumer<CommandeProvider>(
                builder: (context, provider, _) {
                  return CommandeFilter(
                    selectedFilter: provider.selectedFilter,
                    onSelected: (filter) => provider.setFilter(filter),
                  );
                },
              ),

              const SizedBox(height: 35),

              // Liste des commandes
              Expanded(
                child: Consumer<CommandeProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.errorMessage != null) {
                      return Center(
                        child: Text(
                          'Erreur : ${provider.errorMessage}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    final commandes = provider.filteredCommandes;

                    if (commandes.isEmpty) {
                      return const Center(
                        child: Text(
                          'Aucune commande trouvée',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: commandes.length,
                      itemBuilder: (context, index) {
                        return CommandeCard(commande: commandes[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}