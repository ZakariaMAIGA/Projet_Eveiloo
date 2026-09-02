import 'package:eveiloo_enfant/core/constants/AppSpacing.dart';
import 'package:eveiloo_enfant/core/provider/auth_provider.dart';
import 'package:eveiloo_enfant/shared/app_button.dart';
import 'package:eveiloo_enfant/shared/app_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailEnvoye = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String _messageErreurFirebase(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'L\'adresse e-mail est invalide.';
      case 'user-not-found':
        return 'Aucun compte associé à cet e-mail.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessaie plus tard.';
      case 'network-request-failed':
        return 'Vérifie ta connexion Internet.';
      default:
        return exception.message ?? 'L\'envoi a échoué.';
    }
  }

  Future<void> _envoyerLienReinitialisation() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    try {
      await ref
          .read(authActionsProvider.notifier)
          .reinitialiserMotDePasse(_emailController.text.trim());

      if (!mounted) return;

      final erreur = ref.read(authActionsProvider).error;
      if (erreur != null) {
        final message = erreur is FirebaseAuthException
            ? _messageErreurFirebase(erreur)
            : 'Une erreur inattendue est survenue.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
        return;
      }

      setState(() => _emailEnvoye = true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Une erreur inattendue est survenue.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enCours = ref.watch(authActionsProvider).isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: _emailEnvoye
                  ? _buildConfirmation(theme)
                  : _buildFormulaire(theme, enCours),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormulaire(ThemeData theme, bool enCours) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.lock_reset_rounded, size: 72, color: Colors.blue),
          AppSpacing.verticalGapLg,
          Text(
            'Mot de passe oublié ?',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.blue,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.verticalGapSm,
          Text(
            'Entre ton e-mail, nous t\'enverrons un lien pour réinitialiser ton mot de passe.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
          AppSpacing.verticalGapXxl,
          AppInput(
            controller: _emailController,
            label: 'E-mail',
            hint: 'Entre ton e-mail',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            onFieldSubmitted: (_) {
              if (!enCours) _envoyerLienReinitialisation();
            },
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) return 'L\'e-mail est obligatoire.';
              if (!email.contains('@'))
                return 'Saisis une adresse e-mail valide.';
              return null;
            },
          ),
          AppSpacing.verticalGapLg,
          AppButton(
            label: 'Envoyer le lien',
            isLoading: enCours,
            onPressed: _envoyerLienReinitialisation,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmation(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.mark_email_read_rounded,
          size: 72,
          color: Colors.green,
        ),
        AppSpacing.verticalGapLg,
        Text(
          'E-mail envoyé !',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.blue,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        AppSpacing.verticalGapSm,
        Text(
          'Vérifie ta boîte de réception (${_emailController.text.trim()}) et suis le lien pour créer un nouveau mot de passe.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
        AppSpacing.verticalGapXxl,
        AppButton(
          label: 'Retour à la connexion',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ],
    );
  }
}
