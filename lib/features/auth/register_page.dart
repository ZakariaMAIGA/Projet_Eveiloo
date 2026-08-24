import 'package:eveiloo_enfant/core/constants/AppSpacing.dart';
import 'package:eveiloo_enfant/core/services/auth_service.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:eveiloo_enfant/shared/app_button.dart';
import 'package:eveiloo_enfant/shared/app_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _inscription() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.inscription(
        prenom: _prenomController.text,
        nom: _nomController.text,
        courriel: _emailController.text,
        telephone: _telephoneController.text,
        motDePasse: _passwordController.text,
      );

      if (!mounted) return;

      context.goNamed(AppRoutes.homeName);

      // À ajouter après la création de HomePage ou AuthGate :
      //
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (_) => const HomePage()),
      //   (route) => false,
      // );
      //
      // Avec AuthGate, aucune navigation manuelle ne sera nécessaire.
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      _afficherErreur(_messageErreurFirebase(e));
    } catch (_) {
      if (!mounted) return;

      _afficherErreur('Impossible de créer le compte. Réessaie plus tard.');
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

      case 'email-already-in-use':
        return 'Un compte existe déjà avec cette adresse e-mail.';

      case 'weak-password':
        return 'Le mot de passe est trop faible.';

      case 'operation-not-allowed':
        return 'La connexion par e-mail n’est pas activée dans Firebase.';

      case 'network-request-failed':
        return 'Vérifie ta connexion Internet.';

      default:
        return exception.message ?? 'La création du compte a échoué.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.goNamed(AppRoutes.overviewName),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Inscription parent',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.blue,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    AppSpacing.verticalGapMd,

                    Image.asset(
                      'assets/images/logo_eveiloo.png',
                      height: 100,
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
                    AppSpacing.verticalGapLg,

                    Text(
                      'Crée ton compte pour commencer l’aventure Éveiloo.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.blue,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),

                    AppSpacing.verticalGapXxl,

                    AppInput(
                      controller: _prenomController,
                      label: 'Prénom',
                      hint: 'Entre ton prénom',
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.givenName],
                      validator: (value) {
                        if ((value?.trim().length ?? 0) < 2) {
                          return 'Le prénom doit contenir au moins 2 caractères.';
                        }

                        return null;
                      },
                    ),

                    AppSpacing.verticalGapLg,

                    AppInput(
                      controller: _nomController,
                      label: 'Nom',
                      hint: 'Entre ton nom',
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.familyName],
                      validator: (value) {
                        if ((value?.trim().length ?? 0) < 2) {
                          return 'Le nom doit contenir au moins 2 caractères.';
                        }

                        return null;
                      },
                    ),

                    AppSpacing.verticalGapLg,

                    AppInput(
                      controller: _emailController,
                      label: 'E-mail',
                      hint: 'Entre ton e-mail',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [
                        AutofillHints.newUsername,
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
                      controller: _telephoneController,
                      label: 'Téléphone (facultatif)',
                      hint: 'Entre ton numéro',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.telephoneNumber],
                    ),

                    AppSpacing.verticalGapLg,

                    AppInput(
                      controller: _passwordController,
                      label: 'Mot de passe',
                      hint: 'Choisis un mot de passe',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
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
                        if (value == null || value.length < 6) {
                          return 'Le mot de passe doit contenir 6 caractères minimum.';
                        }

                        return null;
                      },
                    ),

                    AppSpacing.verticalGapLg,

                    AppInput(
                      controller: _confirmPasswordController,
                      label: 'Confirmer le mot de passe',
                      hint: 'Saisis à nouveau le mot de passe',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      onFieldSubmitted: (_) {
                        if (!_isLoading) {
                          _inscription();
                        }
                      },
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirme ton mot de passe.';
                        }

                        if (value != _passwordController.text) {
                          return 'Les mots de passe ne correspondent pas.';
                        }

                        return null;
                      },
                    ),

                    AppSpacing.verticalGapXl,

                    AppButton(
                      label: 'Créer mon compte',
                      icon: Icons.person_add_outlined,
                      isLoading: _isLoading,
                      onPressed: _inscription,
                    ),

                    AppSpacing.verticalGapLg,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tu as déjà un compte ? ',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text('Se connecter'),
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
