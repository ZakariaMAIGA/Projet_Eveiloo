import 'package:flutter/material.dart';
import '../../core/constants/AppFontSize.dart';
import '../../core/constants/AppSpacing.dart';
import '../../models/toy_model.dart';

class ToyDetailPage extends StatelessWidget {
  final ToyModel toy;

  const ToyDetailPage({Key? key, required this.toy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(toy.nom), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du jouet
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[200],
              child: toy.imageUrl.isNotEmpty
                  ? Image.network(
                      toy.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.toys, size: 80, color: Colors.grey),
                    )
                  : const Icon(Icons.toys, size: 80, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom et Note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          toy.nom,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSize.large,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${toy.note} (${toy.nombreAvis})',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  AppSpacing.verticalGapSm,

                  // Badge Tranche d'âge
                  Chip(
                    avatar: const Icon(Icons.child_care, size: 18),
                    label: Text('Âge : ${toy.ageRange}'),
                    backgroundColor: theme.primaryColor.withOpacity(0.1),
                    labelStyle: TextStyle(color: theme.primaryColor),
                  ),
                  AppSpacing.verticalGapMd,

                  // Description
                  Text(
                    'Description',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.verticalGapXs,
                  Text(
                    toy.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  AppSpacing.verticalGapLg,

                  // Compétences stimulées (si disponibles)
                  if (toy.competences.isNotEmpty) ...[
                    Text(
                      'Compétences stimulées',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.verticalGapXs,
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: toy.competences
                          .map(
                            (comp) => Chip(
                              label: Text(comp),
                              backgroundColor: Colors.grey[200],
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${toy.nom} ajouté à votre sélection !'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Ajouter à la sélection',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
