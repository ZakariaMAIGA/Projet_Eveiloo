import 'package:flutter/material.dart';
import '../../core/services/order_service.dart';
import '../../models/order_model.dart';
import '../../widgets/order_card.dart';
import 'order_detail_page.dart';

/// Filtres disponibles en haut de l'écran ("Toutes", "En cours", "Livré", "Annuler").
enum _FiltreCommande { toutes, enCours, livree, annulee }

extension on _FiltreCommande {
  String get libelle {
    switch (this) {
      case _FiltreCommande.toutes:
        return 'Toutes';
      case _FiltreCommande.enCours:
        return 'En cours';
      case _FiltreCommande.livree:
        return 'Livré';
      case _FiltreCommande.annulee:
        return 'Annuler';
    }
  }

  StatutCommande? get statut {
    switch (this) {
      case _FiltreCommande.toutes:
        return null;
      case _FiltreCommande.enCours:
        return StatutCommande.enCours;
      case _FiltreCommande.livree:
        return StatutCommande.livree;
      case _FiltreCommande.annulee:
        return StatutCommande.annulee;
    }
  }
}

class OrdersPage extends StatefulWidget {
  final String utilisateurId;

  const OrdersPage({super.key, required this.utilisateurId});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderService _orderService = OrderService();
  _FiltreCommande _filtre = _FiltreCommande.toutes;

  Stream<List<Commande>> get _stream {
    final statut = _filtre.statut;
    if (statut == null) {
      return _orderService.streamCommandes(widget.utilisateurId);
    }
    return _orderService.streamCommandesParStatut(widget.utilisateurId, statut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mes Commandes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            _FiltresRow(
              filtreSelectionne: _filtre,
              onChanged: (f) => setState(() => _filtre = f),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<Commande>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Une erreur est survenue.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final commandes = snapshot.data!;
                  if (commandes.isEmpty) {
                    return const Center(
                      child: Text('Aucune commande pour le moment.'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    itemCount: commandes.length,
                    itemBuilder: (context, index) {
                      final commande = commandes[index];
                      return OrderCard(
                        commande: commande,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  OrderDetailPage(commande: commande),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltresRow extends StatelessWidget {
  final _FiltreCommande filtreSelectionne;
  final ValueChanged<_FiltreCommande> onChanged;

  const _FiltresRow({
    required this.filtreSelectionne,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _FiltreCommande.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filtre = _FiltreCommande.values[index];
          final selectionne = filtre == filtreSelectionne;

          return GestureDetector(
            onTap: () => onChanged(filtre),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    selectionne ? const Color(0xFF3D9BE9) : const Color(0xFFF0F1F3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filtre.libelle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selectionne ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
