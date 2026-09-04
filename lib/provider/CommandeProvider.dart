import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/Commande.dart';
import '../repository/commande_repository.dart';

final commandeProvider = ChangeNotifierProvider<CommandeProvider>((ref) {
  final provider = CommandeProvider();
  ref.onDispose(provider.dispose);
  return provider;
});

class CommandeProvider extends ChangeNotifier {
  final CommandeRepository _repository = CommandeRepository();

  List<Commande> _commandes = [];
  String _selectedFilter = 'Toutes';
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription<List<Commande>>? _subscription;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;

  // Commandes filtrées
  List<Commande> get filteredCommandes {
    switch (_selectedFilter) {
      case 'En cours':
        return _commandes
            .where((c) => c.statut == StatutCommande.enAttente ||
                c.statut == StatutCommande.confirmee ||
                c.statut == StatutCommande.expediee)
            .toList();
      case 'Livrée':
        return _commandes
            .where((c) => c.statut == StatutCommande.livree)
            .toList();
      case 'Annuler':
        return _commandes
            .where((c) => c.statut == StatutCommande.annulee)
            .toList();
      default:
        return _commandes;
    }
  }

  // Écoute du flux Firebase
  void ecouterCommandes(String utilisateurId) {
    if (utilisateurId.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _repository.streamCommandes(utilisateurId).listen(
      (data) {
        _commandes = data;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  // Modifier le filtre
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}