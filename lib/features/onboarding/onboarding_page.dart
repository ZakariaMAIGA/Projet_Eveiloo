import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_route.dart';
import '../../shared/app_button.dart';
import '../../theme/app_colors.dart';

/// Contenu d'une page de l'onboarding
class _OnboardingContent {
  const _OnboardingContent({
    required this.imageAsset,
    required this.title,
    this.welcomeText,
    this.logoAsset,
    this.subtitle,
  });

  final String? welcomeText; // Texte d'accueil ("Bienvenue sur") — page 1
  final String? logoAsset; // Logo coloré sous l'accueil — page 1
  final String title;
  final String? subtitle; // Description sous le titre — page 2
  final String imageAsset;
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_OnboardingContent> _contents = [
    _OnboardingContent(
      welcomeText: 'Bienvenue sur',
      logoAsset: 'assets/images/logo_eveiloo_onboardin.png',
      title: 'Des jeux éducatifs adaptés à chaque âge pour développer '
          'les compétences de vos enfants',
      imageAsset: 'assets/images/enfant_onboarding.png',
    ),
    _OnboardingContent(
      title: 'Suivez les progrès de vos enfants',
      subtitle: 'Visualisez leur réussite, leurs activités et '
          'encouragez-les chaque jour',
      imageAsset: 'assets/images/mere_enfant_onboardind.png',
    ),
  ];

  void _onNext() {
    if (_currentPage < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Fin de l'onboarding -> accueil de l'application
      context.goNamed(AppRoutes.homeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Le retour système ne quitte l'app que depuis la 1re page ;
      // depuis la 2e, il revient à la page précédente de l'onboarding
      canPop: _currentPage == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _pageController.previousPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _contents.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) =>
                      _buildPage(_contents[index]),
                ),
              ),

              // --- Indicateurs de progression (points cliquables) ---
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_contents.length, (index) {
                    final isActive = index == _currentPage;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (index != _currentPage) {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      // Padding = zone tactile élargie autour du point
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 8,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isActive ? 26 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primaryBlue
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit une page de l'onboarding
  Widget _buildPage(_OnboardingContent content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // --- Accueil + Logo (page 1 uniquement) ---
          if (content.welcomeText != null) ...[
            Text(
              content.welcomeText!,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryPink,
              ),
            ),
            const SizedBox(height: 12),
            Image.asset(content.logoAsset!, width: 180),
            const SizedBox(height: 28),
          ],

          // --- Titre principal ---
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: content.subtitle == null ? 24 : 30,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              height: 1.4,
            ),
          ),

          // --- Description (page 2 uniquement) ---
          if (content.subtitle != null) ...[
            const SizedBox(height: 24),
            Text(
              content.subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
                height: 1.5,
              ),
            ),
          ],

          // --- Illustration ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Image.asset(content.imageAsset, fit: BoxFit.contain),
            ),
          ),

          // --- Bouton Suivant (même style que « Connexion » du login) ---
          AppButton(label: 'Suivant', onPressed: _onNext),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}


