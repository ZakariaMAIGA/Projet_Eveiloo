import 'package:eveiloo_enfant/core/constants/AppSpacing.dart';
import 'package:eveiloo_enfant/core/services/auth_service.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';

import 'package:eveiloo_enfant/shared/app_button.dart';
import 'package:eveiloo_enfant/shared/app_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _connexion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.connexion(
        courriel: _emailController.text,
        motDePasse: _passwordController.text,
      );

      if (!mounted) return;

      // Compte existant -> accueil direct (l'onboarding est réservé
      // aux nouveaux comptes créés via l'inscription)
      context.goNamed(AppRoutes.homeName);

      // Si tu ajoutes AuthGate plus tard, il redirigera automatiquement
      // vers HomePage lorsque Firebase détectera la session connectée.
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      _afficherErreur(_messageErreurFirebase(e));
    } catch (_) {
      if (!mounted) return;

      _afficherErreur('Une erreur inattendue est survenue.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _motDePasseOublie() async {
    final courriel = _emailController.text.trim();

    if (courriel.isEmpty) {
      _afficherErreur('Saisis ton adresse e-mail avant de continuer.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.reinitialiserMotDePasse(courriel);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Un e-mail de réinitialisation a été envoyé.'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      _afficherErreur(_messageErreurFirebase(e));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _afficherErreur(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  String _messageErreurFirebase(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'L’adresse e-mail est invalide.';

      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou mot de passe incorrect.';

      case 'user-disabled':
        return 'Ce compte a été désactivé.';

      case 'too-many-requests':
        return 'Trop de tentatives. Réessaie plus tard.';

      case 'network-request-failed':
        return 'Vérifie ta connexion Internet.';

      default:
        return exception.message ?? 'La connexion a échoué.';
    }
  }

  void _ouvrirInscription() {
    context.pushNamed(AppRoutes.registerName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Bonjour !',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.blue,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    AppSpacing.verticalGapSm,

                    Image.asset(
                      'assets/images/logo_eveiloo.png',
                      height: 180,
                      errorBuilder: (context, error, stackTrace) {
                        // Placeholder tant que l'asset n'est pas ajouté au projet
                        return Container(
                          height: 380,
                          width: 380,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.child_care,
                            size: 90,
                            color: Colors.blueAccent,
                          ),
                        );
                      },
                    ),

                    AppSpacing.verticalGapXl,

                    Text(
                      'Connecte-toi à ton compte ',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.blue,
                        height: 2,
                        fontSize: 16,
                      ),
                    ),

                    AppSpacing.verticalGapXxl,

                    AppInput(
                      controller: _emailController,
                      label: 'E-mail',
                      hint: 'Entre ton e-mail',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [
                        AutofillHints.username,
                        AutofillHints.email,
                      ],
                      validator: (value) {
                        final email = value?.trim() ?? '';

                        if (email.isEmpty) {
                          return 'L’e-mail est obligatoire.';
                        }

                        if (!email.contains('@')) {
                          return 'Saisis une adresse e-mail valide.';
                        }

                        return null;
                      },
                    ),

                    AppSpacing.verticalGapLg,

                    AppInput(
                      controller: _passwordController,
                      label: 'Mot de passe',
                      hint: 'Entre ton mot de passe',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) {
                        if (!_isLoading) {
                          _connexion();
                        }
                      },
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le mot de passe est obligatoire.';
                        }

                        return null;
                      },
                    ),

                    AppSpacing.verticalGapSm,

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _isLoading ? null : _motDePasseOublie,
                        child: const Text('Mot de passe oublié ?'),
                      ),
                    ),

                    AppSpacing.verticalGapLg,

                    AppButton(
                      label: 'Connexion',
                      isLoading: _isLoading,
                      onPressed: _connexion,
                    ),

                    AppSpacing.verticalGapXl,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Vous n’avez pas de compte ? ',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        TextButton(
                          onPressed: _isLoading ? null : _ouvrirInscription,
                          child: const Text('S’inscrire'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
