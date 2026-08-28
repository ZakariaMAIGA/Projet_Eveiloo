import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_button.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // Animations d'expansion
  late Animation<double> _blueCircleScale;
  late Animation<double> _pinkCircleScale;
  
  // Animations d'apparition
  late Animation<double> _contentOpacity;
  late Animation<double> _uiOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500), // Animation ralentie pour plus de douceur
    );

    // 1. Cercle Bleu (0% -> 45%)
    _blueCircleScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeInOutCubic),
      ),
    );

    // 2. Cercle Rose (35% -> 75%)
    _pinkCircleScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.75, curve: Curves.easeInOutCubic),
      ),
    );

    // 3. Logo et Nuages (70% -> 90%)
    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: const Interval(0.70, 0.90, curve: Curves.easeOut),
      ),
    );

    // 4. Boutons et Texte (85% -> 100%)
    _uiOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: const Interval(0.85, 1.0, curve: Curves.easeIn),
      ),
    );

    // Diffère le démarrage à la fin du premier rendu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      precacheImage(const AssetImage('assets/images/logo_eveiloo.png'), context);
      precacheImage(const AssetImage('assets/images/cloud.png'), context);
      _controller.forward();
    });
  }

  // Widget pour les petits points décoratifs
  Widget _buildDot(double size, Color color, double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // Taille de base du cercle : la plus petite dimension
    final double coverBase = screenSize.shortestSide;
    // Facteur d'échelle ajusté pour s'assurer de couvrir tout l'écran depuis le centre exact
    final double coverScaleFactor = (screenSize.height * 2.5) / coverBase;

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none, // Très important pour ne pas couper les cercles
            children: [
              
              // --- ÉTAPE 1 : CERCLE BLEU ---
              // L'ajout de Center garantit que l'échelle se déploie depuis le centre de l'écran
              Center(
                child: Transform.scale(
                  scale: _blueCircleScale.value * coverScaleFactor,
                  child: Container(
                    width: coverBase,
                    height: coverBase,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              // --- ÉTAPE 2 : CERCLE ROSE ---
              Center(
                child: Transform.scale(
                  scale: _pinkCircleScale.value * coverScaleFactor,
                  child: Container(
                    width: coverBase,
                    height: coverBase,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryPink,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              
              // --- ÉTAPE 3 : FOND FINAL BLANC ---
              if (_controller.value > 0.70) 
                Container(color: AppColors.backgroundLight),

              // --- ÉTAPE 4 : DÉCORATIONS (Nuages et Dots) ---
              if (_controller.value > 0.70)
                FadeTransition(
                  opacity: _contentOpacity,
                  child: Stack(
                    children: [
                      // Nuage Haut Gauche
                      Positioned(
                        top: screenSize.height * 0.12,
                        left: 40,
                        child: Image.asset('assets/images/cloud.png', width: 90),
                      ),
                      // Nuage Bas Droite
                      Positioned(
                        bottom: screenSize.height * 0.28,
                        right: 30,
                        child: Opacity(
                          opacity: 0.7, 
                          child: Image.asset('assets/images/cloud.png', width: 70),
                        ),
                      ),
                      // Petits points colorés parsemés
                      _buildDot(12, AppColors.primaryBlue, 200, 60),
                      _buildDot(8, AppColors.primaryPink, 150, 180),
                      _buildDot(15, AppColors.primaryBlue.withValues(alpha: 0.4), 500, screenSize.width * 0.8),
                      _buildDot(10, AppColors.primaryPink, 600, 50),
                    ],
                  ),
                ),

              // --- ÉTAPE 5 : CONTENU CENTRAL (Logo et UI) ---
              if (_controller.value > 0.70)
                FadeTransition(
                  opacity: _contentOpacity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 3),
                        // Ton Logo
                        Image.asset('assets/images/logo_eveiloo.png', width: 240),
                        const SizedBox(height: 30),
                        
                        // Slogan
                        FadeTransition(
                          opacity: _uiOpacity,
                          child: const Text(
                            "Apprendre, jouer, grandir\nensemble !",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold, 
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        const Spacer(flex: 2),
                        
                        // Boutons avec navigation vers ta LoginPage
                        FadeTransition(
                          opacity: _uiOpacity,
                          child: Column(
                            children: [
                              AppButton(
                                text: "Se connecter", 
                                onPressed: () {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => const LoginPage())
                                  );
                                },
                              ),
                              const SizedBox(height: 15),
                              AppButton(
                                text: "Créer un compte", 
                                isPrimary: false, 
                                onPressed: () {}
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
