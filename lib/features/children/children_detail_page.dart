import 'package:flutter/material.dart';

class ProfilEnfantDetailScreen extends StatelessWidget {
  const ProfilEnfantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    // Bouton retour
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 32,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Photo
                    const CircleAvatar(
                      radius: 55,
                      backgroundImage: AssetImage(
                        'assets/images/megumi.jpg',
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Nom
                    const Text(
                      'Megumi',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Age
                    const Text(
                      '7 ans',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Progression
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Niveau 4',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '75%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          LinearProgressIndicator(
                            value: 0.75,
                            minHeight: 9,
                            backgroundColor: Colors.grey,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 45),

                    // Mes favoris
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Mes favoris',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Favori 1
                    _favori(),

                    const SizedBox(height: 16),

                    // Favori 2
                    _favori(),

                    const SizedBox(height: 16),

                    // Favori 3
                    _favori(),

                    const SizedBox(height: 40),

                    // Bouton progression
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Voir la progression détaillée',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation
            Container(
              height: 70,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: const [
                  _NavigationItem(
                    icon: Icons.home,
                    label: 'Accueil',
                  ),
                  _NavigationItem(
                    icon: Icons.play_circle,
                    label: 'Tutoriel',
                  ),
                  _NavigationItem(
                    icon: Icons.grid_view,
                    label: 'Catalogue',
                  ),
                  _NavigationItem(
                    icon: Icons.directions_run,
                    label: 'Activité',
                  ),
                  _NavigationItem(
                    icon: Icons.person,
                    label: 'Profil',
                    active: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Carte d'un favori
  static Widget _favori() {
    return Container(
      height: 70,
      width: double.infinity,

      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/puzzle.png',
              width: 80,
              height: 55,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 15),

          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Puzzle en bois',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),

              SizedBox(height: 8),

              Text(
                '5-7 ans',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Élément de navigation
class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavigationItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: active ? Colors.blue : Colors.black,
          size: 28,
        ),

        const SizedBox(height: 3),

        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: active ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }
}