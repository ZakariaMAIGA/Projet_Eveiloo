import 'package:flutter/material.dart';
import '../../core/constants/AppSpacing.dart';
import '../../core/constants/AppFontSize.dart';
import '../../models/Commande.dart';
import '../../models/commande_article_model.dart';
import '../../repository/commande_repository.dart';

class CommandeDetailPage extends StatelessWidget {
  final String commandeId;

  const CommandeDetailPage({Key? key, required this.commandeId})
    : super(key: key);

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
    final repository = CommandeRepository();

    return Scaffold(
      appBar: AppBar(title: const Text('Détail de la commande')),
      body: FutureBuilder<Commande?>(
        future: repository.obtenirCommande(commandeId),
        builder: (context, commandeSnapshot) {
          if (commandeSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final commande = commandeSnapshot.data;
          if (commande == null) {
            return const Center(child: Text('Commande introuvable.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- EN-TÊTE COMMANDE ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Commande #${commande.numeroCommande}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSize.medium,
                              ),
                            ),
                            Chip(
                              label: Text(commande.statut.name),
                              backgroundColor: _statutColor(
                                commande.statut,
                              ).withOpacity(0.15),
                              labelStyle: TextStyle(
                                color: _statutColor(commande.statut),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Adresse : ${commande.adresseLivraison}'),
                        if (commande.dateCommande != null)
                          Text('Date : ${commande.dateCommande}'),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Total : ${commande.montantTotal.toInt()} FCFA',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF29B6F6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Articles',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSize.medium,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // --- LISTE DES ARTICLES ---
                StreamBuilder<List<CommandeArticleModel>>(
                  stream: repository.streamArticlesCommande(commandeId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final articles = snapshot.data ?? [];
                    if (articles.isEmpty) {
                      return const Text('Aucun article.');
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final item = articles[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: item.urlImage.isNotEmpty
                                      ? Image.network(
                                          item.urlImage,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.smart_toy_rounded,
                                                    color: Colors.grey,
                                                  ),
                                        )
                                      : const Icon(
                                          Icons.smart_toy_rounded,
                                          color: Colors.grey,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.nom,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${item.quantite} x ${item.prixUnitaire.toInt()} FCFA',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: AppFontSize.small,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${item.sousTotal.toInt()} FCFA',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
