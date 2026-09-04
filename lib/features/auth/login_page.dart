import 'package:eveiloo_enfant/core/constants/AppSpacing.dart';
import 'package:eveiloo_enfant/core/provider/auth_provider.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:eveiloo_enfant/shared/app_button.dart';
import 'package:eveiloo_enfant/shared/app_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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

    // Lance la connexion via Riverpod
    await ref
        .read(authActionsProvider.notifier)
        .connexion(
          courriel: _emailController.text,
          motDePasse: _passwordController.text,
        );

    if (!mounted) return;

    final authState = ref.read(authActionsProvider);

    if (authState.hasError) {
      // Affiche l’erreur Firebase
      final error = authState.error;
      final message = _messageErreurFirebase(error);
      _afficherErreur(message);

      // Reset l’état pour permettre un nouvel essai
      ref.read(authActionsProvider.notifier).state = const AsyncValue.data(
        null,
      );
      return;
    }

    // Succès : navigation
    // Si tu as un AuthGate :
    // context.go('/');
    // Sinon, vers home directement :
    context.goNamed(AppRoutes.homeName);
  }

  void _afficherErreur(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  String _messageErreurFirebase(Object? error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
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
          return error.message ?? 'La connexion a échoué.';
      }
    }

    return 'Une erreur est survenue. Vérifie tes identifiants et ta connexion.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final connexionEnCours = ref.watch(authActionsProvider).isLoading;

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
                        if (!connexionEnCours) {
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
                        onPressed: connexionEnCours
                            ? null
                            : () => context.pushNamed(
                                AppRoutes.forgotPasswordName,
                              ),
                        child: const Text('Mot de passe oublié ?'),
                      ),
                    ),

                    AppSpacing.verticalGapLg,

                    AppButton(
                      label: 'Connexion',
                      isLoading: connexionEnCours,
                      onPressed: connexionEnCours ? null : _connexion,
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
                          onPressed: connexionEnCours
                              ? null
                              : () {
                                  context.pushNamed(AppRoutes.registerName);
                                },
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
