import 'package:eveiloo_enfant/core/provider/auth_provider.dart';
import 'package:eveiloo_enfant/core/provider/enfant_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/enfant.dart';
import '../../models/journal_progres_model.dart';
import '../../repository/journal_progres_repository.dart';
import '../../routes/app_route.dart';
import '../activities/activity_service.dart';

// Widgets extraits
import 'widgets/section_title.dart';
import 'widgets/entete_profil.dart';
import 'widgets/barre_progression.dart';
import 'widgets/activity_card_premium.dart';
import 'widgets/grille_actions_premium.dart';

// ---------------------------------------------------------------------------
// Providers locaux
// ---------------------------------------------------------------------------
final journalProgresRepositoryProvider = Provider<JournalProgresRepository>((
  ref,
) {
  return JournalProgresRepository();
});

final activityServiceProvider = Provider<ActivityService>((ref) {
  return ActivityService();
});

/// Stream d'un enfant précis
final enfantParIdProvider = StreamProvider.family<EnfantModel?, String>((
  ref,
  enfantId,
) {
  final utilisateur = ref.watch(utilisateurCourantProvider).value;
  if (utilisateur == null) return Stream.value(null);

  return ref
      .watch(enfantRepositoryProvider)
      .observerEnfantParId(utilisateur.utilisateurId, enfantId);
});

// ---------------------------------------------------------------------------
// Page principale
// ---------------------------------------------------------------------------
class ChildrenProfil extends ConsumerStatefulWidget {
  final String enfantId;

  const ChildrenProfil({super.key, required this.enfantId});

  @override
  ConsumerState<ChildrenProfil> createState() => _ChildrenProfilState();
}

class _ChildrenProfilState extends ConsumerState<ChildrenProfil> {
  static const int _objectifPalier = 25;

  String _libelleNiveau(int activitesRealisees) {
    if (activitesRealisees >= 25) return 'Maître de l\'aventure 🌟';
    if (activitesRealisees >= 15) return 'Super Explorateur 🚀';
    if (activitesRealisees >= 5) return 'Apprenti Curieux 🔎';
    return 'Petit Débutant 🌱';
  }

  double _valeurProgression(int activitesRealisees) {
    return (activitesRealisees / _objectifPalier).clamp(0.0, 1.0);
  }

  String _descriptionEntree(JournalProgresModel entree, String prenom) {
    return entree.typeElement == TypeElementProgres.tutoriel
        ? '$prenom a regardé un tutoriel captivant'
        : '$prenom a complété une activité avec succès';
  }

  String _tempsEcoule(DateTime? date) {
    if (date == null) return '';

    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return 'Il y a $h ${h > 1 ? 'heures' : 'heure'}';
    }

    final j = diff.inDays;
    return 'Il y a $j ${j > 1 ? 'jours' : 'jour'}';
  }

  Future<void> _ouvrirEntreeJournal(JournalProgresModel entree) async {
    if (entree.typeElement == TypeElementProgres.tutoriel) {
      if (!mounted) return;
      // Bascule vers la branche Tutoriels du shell enfant (index à ajuster
      // selon l'ordre réel des branches dans childShellRoute)
      StatefulNavigationShell.of(context).goBranch(2);
      return;
    }

    final activityService = ref.read(activityServiceProvider);
    final activite = await activityService.getActivity(entree.elementId);

    if (activite == null || !mounted) return;

    context.pushNamed(
      AppRoutes.childActivityDetailName,
      pathParameters: {'enfantId': widget.enfantId},
      extra: (activity: activite, enfantId: widget.enfantId),
    );
  }

  void _voirToutHistorique() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Historique complet — bientôt disponible ! ✨'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Vérification du mot de passe parent avant de quitter le dashboard
  // ---------------------------------------------------------------------

  /// Affiche la boîte de dialogue de vérification et retourne `true`
  /// uniquement si le mot de passe saisi est correct.
  Future<bool> _demanderMotDePasseParent() async {
    final resultat = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _DialogVerificationParent(),
    );
    return resultat ?? false;
  }

  Future<void> _tenterSortie() async {
    final autorise = await _demanderMotDePasseParent();
    if (autorise && mounted) {
      context.goNamed(AppRoutes.childrenListName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enfantAsync = ref.watch(enfantParIdProvider(widget.enfantId));

    return PopScope(
      // Bloque aussi le retour système (geste / bouton physique Android)
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _tenterSortie();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF29258F),
                size: 20,
              ),
            ),
            onPressed: _tenterSortie,
          ),
          title: const Text(
            'Profil',
            style: TextStyle(
              color: Color(0xFF29258F),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: enfantAsync.when(
          data: (enfant) {
            if (enfant == null) {
              return const Center(
                child: Text(
                  'Enfant introuvable.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return _buildContent(enfant);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF29258F)),
          ),
          error: (_, __) =>
              const Center(child: Text('Une erreur est survenue.')),
        ),
      ),
    );
  }

  Widget _buildContent(EnfantModel enfant) {
    final journalRepo = ref.watch(journalProgresRepositoryProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40, top: 10),
      child: Column(
        children: [
          EnteteProfil(nomEnfant: enfant.prenom, urlAvatar: enfant.urlAvatar),
          const SizedBox(height: 24),
          BarreProgression(
            niveau: _libelleNiveau(enfant.activitesRealisees),
            numeroNiveau: enfant.niveauAtteint,
            valeur: _valeurProgression(enfant.activitesRealisees),
            activitesRealisees: enfant.activitesRealisees,
            objectif: _objectifPalier,
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionTitle(title: 'Activités Récentes ✨'),
                GestureDetector(
                  onTap: _voirToutHistorique,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Voir tout',
                        style: TextStyle(
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF6C63FF),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          StreamBuilder<List<JournalProgresModel>>(
            stream: journalRepo.observerActivitesRecentes([
              widget.enfantId,
            ], limite: 3),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const SizedBox.shrink();

              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(color: Color(0xFF29258F)),
                );
              }

              final entrees = snapshot.data!;

              if (entrees.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text(
                    'Aucune aventure pour le moment, c\'est l\'heure de jouer !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: entrees.map((entree) {
                    return ActivityCardPremium(
                      urlAvatar: enfant.urlAvatar,
                      titre: entree.titre,
                      description: _descriptionEntree(entree, enfant.prenom),
                      tempsEcoule: _tempsEcoule(entree.dateRealisation),
                      onTap: () => _ouvrirEntreeJournal(entree),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          GrilleActionsPremium(
            enfantId: widget.enfantId,
          ), // ← corrigé (pas const, pas "enfant")
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Boîte de dialogue de vérification du mot de passe parent
// ---------------------------------------------------------------------------
class _DialogVerificationParent extends StatefulWidget {
  const _DialogVerificationParent();

  @override
  State<_DialogVerificationParent> createState() =>
      _DialogVerificationParentState();
}

class _DialogVerificationParentState extends State<_DialogVerificationParent> {
  final TextEditingController _motDePasseController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _obscurer = true;
  bool _verificationEnCours = false;
  String? _erreur;

  @override
  void dispose() {
    _motDePasseController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _verifier() async {
    final motDePasse = _motDePasseController.text;

    if (motDePasse.isEmpty) {
      setState(() => _erreur = 'Veuillez saisir le mot de passe.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    if (user == null || email == null) {
      setState(() => _erreur = 'Session expirée, reconnectez-vous.');
      return;
    }

    setState(() {
      _verificationEnCours = true;
      _erreur = null;
    });

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: motDePasse,
      );
      // Ré-authentification réelle contre Firebase Auth : si le mot de
      // passe est incorrect, ceci lève une FirebaseAuthException.
      await user.reauthenticateWithCredential(credential);

      if (mounted) Navigator.of(context).pop(true);
    } on FirebaseAuthException catch (e) {
      final message =
          (e.code == 'wrong-password' || e.code == 'invalid-credential')
          ? 'Mot de passe incorrect.'
          : 'Erreur : ${e.message ?? e.code}';
      setState(() {
        _erreur = message;
        _verificationEnCours = false;
      });
    } catch (_) {
      setState(() {
        _erreur = 'Une erreur est survenue, réessayez.';
        _verificationEnCours = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF29258F).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFF29258F),
                size: 26,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Espace parent',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF29258F),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Saisissez votre mot de passe pour quitter l\'espace enfant.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _motDePasseController,
              focusNode: _focusNode,
              obscureText: _obscurer,
              autofocus: true,
              enabled: !_verificationEnCours,
              onSubmitted: (_) => _verifier(),
              decoration: InputDecoration(
                hintText: 'Mot de passe',
                errorText: _erreur,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurer
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscurer = !_obscurer),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _verificationEnCours
                        ? null
                        : () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _verificationEnCours ? null : _verifier,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF29258F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _verificationEnCours
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Confirmer',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
