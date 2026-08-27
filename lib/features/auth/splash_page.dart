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
  late Animation<double> _blueCircleScale;
  late Animation<double> _pinkCircleScale;
  late Animation<double> _contentOpacity;
  late Animation<double> _uiOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _blueCircleScale = Tween<double>(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.35, curve: Curves.easeIn)),
    );

    _pinkCircleScale = Tween<double>(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.25, 0.55, curve: Curves.easeIn)),
    );

    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.55, 0.8, curve: Curves.easeOut)),
    );

    _uiOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();
  }

  // Fonction pour créer les petits cercles décoratifs
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Cercles d'arrière-plan
              Transform.scale(
                scale: _blueCircleScale.value,
                child: Container(width: 100, height: 100, decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle)),
              ),
              Transform.scale(
                scale: _pinkCircleScale.value,
                child: Container(width: 100, height: 100, decoration: const BoxDecoration(color: AppColors.primaryPink, shape: BoxShape.circle)),
              ),
              
              if (_controller.value > 0.54) Container(color: AppColors.backgroundLight),

              // --- ÉLÉMENTS DÉCORATIFS (Nuages et Cercles) ---
              if (_controller.value > 0.55)
                FadeTransition(
                  opacity: _contentOpacity,
                  child: Stack(
                    children: [
                      // Nuage en haut à gauche
                      Positioned(
                        top: 100,
                        left: 40,
                        child: Image.asset('assets/images/cloud.png', width: 80),
                      ),
                      // Nuage en bas à droite (un peu plus petit et décalé)
                      Positioned(
                        bottom: 220,
                        right: 30,
                        child: Opacity(
                          opacity: 0.7, 
                          child: Image.asset('assets/images/cloud.png', width: 60),
                        ),
                      ),

                      // Petits cercles parsemés (comme sur la vidéo)
                      _buildDot(12, AppColors.primaryBlue, 180, 50),
                      _buildDot(8, AppColors.primaryPink, 140, 150),
                      _buildDot(15, AppColors.primaryBlue.withOpacity(0.5), 450, 300),
                      _buildDot(10, AppColors.primaryPink, 550, 60),
                      _buildDot(20, Colors.yellow.withOpacity(0.3), 120, 280),
                    ],
                  ),
                ),

              // --- LOGO ET BOUTONS ---
              if (_controller.value > 0.55)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 3),
                      Image.asset('assets/logos/eveiloo_logo.png', width: 230),
                      const SizedBox(height: 30),
                      FadeTransition(
                        opacity: _uiOpacity,
                        child: const Text(
                          "Apprendre, jouer, grandir\nensemble !",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 19, 
                            fontWeight: FontWeight.bold, 
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),
                      FadeTransition(
                        opacity: _uiOpacity,
                        child: Column(
                          children: [
                            AppButton(
                              text: "Se connecter", 
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage())),
                            ),
                            const SizedBox(height: 12),
                            AppButton(text: "Créer un compte", isPrimary: false, onPressed: () {}),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}