import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/order_model.dart';
import '../../models/payment_model.dart';
import 'order_service.dart';

/// Résultat renvoyé après une tentative de paiement.
class ResultatPaiement {
  final bool succes;
  final Commande? commande;
  final PaiementModel? paiement;
  final String? messageErreur;

  ResultatPaiement.succesAvec({required this.commande, required this.paiement})
      : succes = true,
        messageErreur = null;

  ResultatPaiement.echec(this.messageErreur)
      : succes = false,
        commande = null,
        paiement = null;
}

/// Service de paiement "light" : pas de véritable passerelle bancaire,
/// on simule la validation (utile en attendant l'intégration Orange Money /
/// Moov Money / carte bancaire réelle), puis on persiste la commande et
/// le paiement dans Firestore.
///
/// Structure Firestore utilisée :
///   paiements/{paiementId}
class PaymentService {
  final FirebaseFirestore _firestore;
  final OrderService _orderService;

  PaymentService({
    FirebaseFirestore? firestore,
    OrderService? orderService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _orderService = orderService ?? OrderService(firestore: firestore);

  CollectionReference<Map<String, dynamic>> get _paiementsRef =>
      _firestore.collection('paiements');

  /// Vérifie le code secret saisi par l'utilisateur.
  ///
  /// En "light", on valide simplement le format (4 chiffres minimum).
  /// À remplacer par l'appel réel à l'API Orange Money / Moov Money
  /// lorsqu'elle sera disponible.
  bool codeSecretValide(String code) {
    return RegExp(r'^\d{4,}$').hasMatch(code.trim());
  }

  /// Déroule le paiement : crée la commande, puis le paiement associé.
  ///
  /// - Pour Orange Money / Moov Money : [codeSecret] est requis et vérifié.
  /// - Pour carte bancaire / espèces à la livraison : [codeSecret] est ignoré.
  Future<ResultatPaiement> effectuerPaiement({
    required String utilisateurId,
    required String adresseLivraison,
    required double montant,
    required MethodePaiement methode,
    String? codeSecret,
  }) async {
    if (methode.necessiteCodeSecret) {
      if (codeSecret == null || !codeSecretValide(codeSecret)) {
        return ResultatPaiement.echec('Code secret invalide.');
      }
    }

    try {
      // 1. Création de la commande (statut "En cours" une fois payée).
      final commande = await _orderService.creerCommande(
        utilisateurId: utilisateurId,
        adresseLivraison: adresseLivraison,
        montantTotal: montant,
        methodePaiement: methode.code,
        statutInitial: StatutCommande.enCours,
      );

      // 2. Enregistrement du paiement.
      final paiementRef = _paiementsRef.doc();
      final paiement = PaiementModel(
        paiementId: paiementRef.id,
        commandeId: commande.commandeId,
        utilisateurId: utilisateurId,
        montant: montant,
        methode: methode,
        statut: StatutPaiement.valide,
        dateCreation: DateTime.now(),
      );
      await paiementRef.set(paiement.toFirestore());

      return ResultatPaiement.succesAvec(commande: commande, paiement: paiement);
    } catch (e) {
      return ResultatPaiement.echec('Le paiement a échoué. Réessaie.');
    }
  }
}
