import 'dart:async';
import 'package:flutter/material.dart';
import '../models/commande.dart';
import '../repository/CommandeRepository.dart';

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
            .where((c) => c.statut.toLowerCase() == 'en_cours' || c.statut.toLowerCase() == 'en cours')
            .toList();
      case 'Livrée':
        return _commandes
            .where((c) => c.statut.toLowerCase() == 'livree' || c.statut.toLowerCase() == 'livrée')
            .toList();
      case 'Annuler':
        return _commandes
            .where((c) => c.statut.toLowerCase() == 'annulee' || c.statut.toLowerCase() == 'annulée')
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
    _subscription = _repository.getCommandesUtilisateur(utilisateurId).listen(
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