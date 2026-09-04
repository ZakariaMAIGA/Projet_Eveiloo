import 'package:eveiloo_enfant/core/provider/auth_provider.dart';
import 'package:eveiloo_enfant/shared/app_button.dart';
import 'package:eveiloo_enfant/shared/app_button_outline.dart';
import 'package:eveiloo_enfant/shared/app_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kBleu = Color(0xFF42A5F5);

class ModifierProfilPage extends ConsumerStatefulWidget {
  const ModifierProfilPage({super.key});

  @override
  ConsumerState<ModifierProfilPage> createState() => _ModifierProfilPageState();
}

class _ModifierProfilPageState extends ConsumerState<ModifierProfilPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _prenomCtrl;
  late final TextEditingController _nomCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _telephoneCtrl;
  final _motDePasseCtrl = TextEditingController();

  bool _motDePasseVisible = false;
  bool _enCours = false;

  @override
  void initState() {
    super.initState();
    // On pre-remplit avec les valeurs deja chargees sur la page profil
    // (pas besoin de refaire un appel reseau ici).
    final utilisateur = ref.read(utilisateurCourantProvider).value;
    _prenomCtrl = TextEditingController(text: utilisateur?.prenom ?? '');
    _nomCtrl = TextEditingController(text: utilisateur?.nom ?? '');
    _emailCtrl = TextEditingController(text: utilisateur?.courriel ?? '');
    _telephoneCtrl = TextEditingController(text: utilisateur?.telephone ?? '');
  }

  @override
  void dispose() {
    _prenomCtrl.dispose();
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telephoneCtrl.dispose();
    _motDePasseCtrl.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    final utilisateur = ref.read(utilisateurCourantProvider).value;
    if (utilisateur == null) return;

    setState(() => _enCours = true);

    try {
      await ref.read(utilisateurRepositoryProvider).mettreAJour(
        utilisateur.utilisateurId,
        {
          'prenom': _prenomCtrl.text.trim(),
          'nom': _nomCtrl.text.trim(),
          'telephone': _telephoneCtrl.text.trim(),
          // NB: le courriel Firestore est mis a jour ici, mais changer
          // l'email de connexion Firebase Auth demande une re-authentification
          // recente (verifyBeforeUpdateEmail) : a faire dans un flux dedie
          // si tu veux vraiment permettre ce changement.
          'courriel': _emailCtrl.text.trim().toLowerCase(),
        },
      );

      if (_motDePasseCtrl.text.trim().isNotEmpty) {
        await ref
            .read(authServiceProvider)
            .modifierMotDePasse(_motDePasseCtrl.text.trim());
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    } finally {
      if (mounted) setState(() => _enCours = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Modifier le profil',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _kBleu,
                ),
              ),
              const SizedBox(height: 28),

              AppInput(
                controller: _prenomCtrl,
                label: 'Prénom',
                hint: 'Entrez votre prénom',
                prefixIcon: Icons.person_outline,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Prénom requis' : null,
              ),
              const SizedBox(height: 16),

              AppInput(
                controller: _nomCtrl,
                label: 'Nom',
                hint: 'Entrez votre nom',
                prefixIcon: Icons.person_outline,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
              ),
              const SizedBox(height: 16),

              AppInput(
                controller: _emailCtrl,
                label: 'Email',
                hint: 'Entrez votre  email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email requis';
                  if (!v.contains('@')) return 'Email invalide';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              AppInput(
                controller: _telephoneCtrl,
                label: 'Telephone',
                hint: 'Entre votre numero',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              AppInput(
                controller: _motDePasseCtrl,
                label: 'Mot de passe',
                hint: 'Saisir votre  mot passe',
                prefixIcon: Icons.lock_outline,
                obscureText: !_motDePasseVisible,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _enregistrer(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _motDePasseVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _motDePasseVisible = !_motDePasseVisible),
                ),
                // Champ optionnel : laisse vide = mot de passe inchange.
                validator: (v) {
                  if (v != null && v.isNotEmpty && v.length < 6) {
                    return 'Au moins 6 caractères';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Modifier',
                      isLoading: _enCours,
                      onPressed: _enregistrer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppOutlineButton(
                      label: 'Annuler',
                      onPressed: _enCours
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
