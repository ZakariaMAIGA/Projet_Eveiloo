import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/order_model.dart';

/// Service de gestion des commandes via Firestore.
///
/// Structure Firestore utilisée :
///   commandes/{commandeId}
///   compteurs/commandes  -> { dernierNumero: int }  (pour le "#1234")
class OrderService {
  final FirebaseFirestore _firestore;

  OrderService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _commandesRef =>
      _firestore.collection('commandes');

  DocumentReference<Map<String, dynamic>> get _compteurRef =>
      _firestore.collection('compteurs').doc('commandes');

  /// Écoute en temps réel toutes les commandes d'un utilisateur,
  /// triées de la plus récente à la plus ancienne.
  Stream<List<Commande>> streamCommandes(String utilisateurId) {
    return _commandesRef
        .where('utilisateurId', isEqualTo: utilisateurId)
        .orderBy('dateCommande', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Commande.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  /// Écoute uniquement les commandes ayant un statut donné.
  Stream<List<Commande>> streamCommandesParStatut(
    String utilisateurId,
    StatutCommande statut,
  ) {
    return _commandesRef
        .where('utilisateurId', isEqualTo: utilisateurId)
        .where('statut', isEqualTo: statut.valeur)
        .orderBy('dateCommande', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Commande.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  /// Récupère une commande précise.
  Future<Commande?> obtenirCommande(String commandeId) async {
    final doc = await _commandesRef.doc(commandeId).get();
    if (!doc.exists) return null;
    return Commande.fromFirestore(doc.data()!, doc.id);
  }

  /// Génère le prochain numéro de commande de façon atomique (ex: 1234, 1235...).
  Future<int> _prochainNumero() {
    return _firestore.runTransaction<int>((transaction) async {
      final snapshot = await transaction.get(_compteurRef);
      final dernier =
          (snapshot.data()?['dernierNumero'] as num?)?.toInt() ?? 1233;
      final prochain = dernier + 1;
      transaction.set(_compteurRef, {'dernierNumero': prochain});
      return prochain;
    });
  }

  /// Crée une nouvelle commande (appelée à la fin du checkout) et retourne
  /// la commande créée avec son identifiant Firestore et son numéro affiché.
  Future<Commande> creerCommande({
    required String utilisateurId,
    required String adresseLivraison,
    required double montantTotal,
    String? methodePaiement,
    StatutCommande statutInitial = StatutCommande.enCours,
  }) async {
    final numero = await _prochainNumero();
    final docRef = _commandesRef.doc();

    final commande = Commande(
      commandeId: docRef.id,
      numero: numero,
      utilisateurId: utilisateurId,
      adresseLivraison: adresseLivraison,
      montantTotal: montantTotal,
      statut: statutInitial,
      methodePaiement: methodePaiement,
      dateCommande: DateTime.now(),
    );

    await docRef.set(commande.toFirestore());
    return commande;
  }

  /// Met à jour le statut d'une commande (ex: après livraison ou annulation).
  Future<void> mettreAJourStatut(
    String commandeId,
    StatutCommande statut,
  ) {
    return _commandesRef.doc(commandeId).update({'statut': statut.valeur});
  }

  /// Annule une commande.
  Future<void> annulerCommande(String commandeId) {
    return mettreAJourStatut(commandeId, StatutCommande.annulee);
  }
}
