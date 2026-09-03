import 'package:eveiloo_enfant/provider/CommandeProvider.dart';
import 'package:eveiloo_enfant/widgets/commande_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import '../../core/services/auth_service.dart';
 
import '../../widgets/commande_filter.dart';

class MesCommandesPage extends ConsumerStatefulWidget {
  const MesCommandesPage({super.key});

  @override
  ConsumerState<MesCommandesPage> createState() => _MesCommandesPageState();
}

class _MesCommandesPageState extends ConsumerState<MesCommandesPage> {
  @override
  void initState() {
    super.initState();
    // Initialisation de l'écoute des commandes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parentId = AuthService().utilisateurFirebase?.uid ?? '';
      ref.read(commandeProvider).ecouterCommandes(parentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        leading: IconButton(
          tooltip: 'Retour',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
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
              Builder(
                builder: (context) {
                  final provider = ref.watch(commandeProvider);
                  return CommandeFilter(
                    selectedFilter: provider.selectedFilter,
                    onSelected: provider.setFilter,
                  );
                },
              ),

              const SizedBox(height: 35),

              // Liste des commandes
              Expanded(
                child: Builder(
                  builder: (context) {
                    final provider = ref.watch(commandeProvider);
                    if (AuthService().utilisateurFirebase == null) {
                      return const Center(
                        child: Text('Veuillez vous connecter pour voir vos commandes.'),
                      );
                    }

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