import 'package:eveiloo_enfant/core/constants/AppFontSize.dart';
import 'package:eveiloo_enfant/core/constants/AppSpacing.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:eveiloo_enfant/shared/app_button.dart';
import 'package:eveiloo_enfant/shared/app_button_outline.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              AppSpacing.verticalGapMd,

              
              // Logo / mascotte (remplacer par l'asset réel du logo Eveiloo)
              Image.asset(
                'assets/images/logo_eveiloo.png',
                height: 380,
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

              AppSpacing.verticalGapMd,

              // Tagline
              const Text(
                'Apprendre, jouer, grandir\nensemble !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSize.large,
                  height: 1.4,
                  color: Color(0xFF4A4A4A),
                  fontWeight: FontWeight.w900,
                ),
              ),

              const Spacer(flex: 3),

              // Bouton principal "Se connecter"
              AppButton(
                label: "Se connecter",
                onPressed: () {
                  context.goNamed(AppRoutes.loginName);
                },
              ),

              AppSpacing.verticalGapMd,

              // Bouton secondaire "Créer un compte"
              AppOutlineButton(
                label: 'Créer un compte',
                onPressed: () {
                  context.goNamed(AppRoutes.registerName);
                },
              ),

              AppSpacing.verticalGapLg,
            ],
          ),
        ),
      ),
    );
  }
}
