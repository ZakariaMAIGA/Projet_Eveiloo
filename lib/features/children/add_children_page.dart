import 'package:eveiloo_enfant/core/services/children_service.dart';
import 'package:eveiloo_enfant/models/enfant.dart';
import 'package:eveiloo_enfant/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilEnfantPage extends StatefulWidget {
  const ProfilEnfantPage({super.key});

  @override
  State<ProfilEnfantPage> createState() => _ProfilEnfantPageState();
}

class _ProfilEnfantPageState extends State<ProfilEnfantPage> {
  final EnfantService _enfantService = EnfantService();

  final TextEditingController prenomController = TextEditingController();

  final TextEditingController nomController = TextEditingController();

  final TextEditingController dateController = TextEditingController();

  final TextEditingController niveauController = TextEditingController();

  final TextEditingController centresInteretController =
      TextEditingController();

  String? genre;

  bool isLoading = false;

  @override
  void dispose() {
    prenomController.dispose();
    nomController.dispose();
    dateController.dispose();
    niveauController.dispose();
    centresInteretController.dispose();
    super.dispose();
  }

  // =========================
  // CHOISIR LA DATE
  // =========================

  Future<void> choisirDate() async {
    final DateTime? dateChoisie = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (dateChoisie != null) {
      setState(() {
        dateController.text =
            '${dateChoisie.day.toString().padLeft(2, '0')}/'
            '${dateChoisie.month.toString().padLeft(2, '0')}/'
            '${dateChoisie.year}';
      });
    }
  }

  // =========================
  // ENREGISTRER LE PROFIL
  // =========================

  Future<void> enregistrerProfil() async {
    // Vérification prénom
    if (prenomController.text.trim().isEmpty) {
      _afficherMessage('Veuillez entrer le prénom de l’enfant');
      return;
    }

    // Vérification date
    if (dateController.text.trim().isEmpty) {
      _afficherMessage('Veuillez sélectionner la date de naissance');
      return;
    }

    // Vérification genre
    if (genre == null) {
      _afficherMessage('Veuillez sélectionner le genre');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Création du modèle enfant
      final EnfantModel enfant = EnfantModel(
        enfantId: '',
        prenom: prenomController.text.trim(),
        nom: nomController.text.trim(),
        dateNaissance: dateController.text.trim(),
        genre: genre!,
        niveauScolaire: niveauController.text.trim(),
        centresInteret: centresInteretController.text.trim(),
        urlAvatar: '',
        niveauAtteint: 0,
        pointsGagnes: 0,
        activitesRealisees: 0,
      );

      // Enregistrement via le Service
      await _enfantService.ajouterEnfant(enfant);

      if (!mounted) return;

      _afficherMessage('Profil enregistré avec succès', couleur: Colors.green);

      // Retour vers Mes Enfants
      context.go(AppRoutes.childrenList);
    } catch (e) {
      if (!mounted) return;

      _afficherMessage(
        'Erreur lors de l’enregistrement : $e',
        couleur: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =========================
  // MESSAGE
  // =========================

  void _afficherMessage(String message, {Color couleur = Colors.orange}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: couleur));
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // RETOUR
              // =========================

              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.blue,
                  size: 28,
                ),
                onPressed: () {
                  context.go(AppRoutes.childrenList);
                },
              ),

              const SizedBox(height: 10),

              // =========================
              // TITRE
              // =========================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Profil de l’enfant',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          'Renseignez les informations de votre enfant '
                          'pour personnaliser son expérience',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  Image.asset(
                    'assets/images/petit.png',
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.child_care,
                        size: 60,
                        color: Colors.orange,
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // =========================
              // PHOTO
              // =========================
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Ajouter une photo',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Text(
                      '(optionnel)',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // PRÉNOM
              // =========================
              _buildTextField(
                icon: Icons.person,
                iconColor: Colors.redAccent,
                title: 'Prénom de l’enfant',
                hint: 'Entrez le prénom',
                controller: prenomController,
              ),

              // =========================
              // NOM
              // =========================
              _buildTextField(
                icon: Icons.person,
                iconColor: Colors.redAccent,
                title: 'Nom de l’enfant',
                subtitle: '(optionnel)',
                hint: 'Entrez le nom',
                controller: nomController,
              ),

              // =========================
              // DATE DE NAISSANCE
              // =========================
              _buildTextField(
                icon: Icons.calendar_today,
                iconColor: Colors.orangeAccent,
                title: 'Date de naissance',
                hint: 'Sélectionnez la date',
                controller: dateController,
                readOnly: true,
                onTap: choisirDate,
              ),

              // =========================
              // GENRE
              // =========================
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Genre',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderOption(
                            label: 'Garçon',
                            icon: Icons.face,
                            iconColor: Colors.brown,
                            value: 'Garçon',
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _buildGenderOption(
                            label: 'Fille',
                            icon: Icons.face,
                            iconColor: Colors.purple,
                            value: 'Fille',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // =========================
              // NIVEAU SCOLAIRE
              // =========================
              _buildTextField(
                icon: Icons.school,
                iconColor: Colors.amber,
                title: 'Niveau scolaire',
                subtitle: '(optionnel)',
                hint: 'Ex: CP1, CE1, CM1...',
                controller: niveauController,
              ),

              // =========================
              // CENTRES D'INTÉRÊT
              // =========================
              _buildTextField(
                icon: Icons.star,
                iconColor: Colors.orange,
                title: 'Centres d’intérêt',
                subtitle: '(optionnel)',
                hint: 'Ex: Animaux, Espace, Dessin...',
                controller: centresInteretController,
              ),

              const SizedBox(height: 25),

              // =========================
              // BOUTON
              // =========================
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: isLoading ? null : enregistrerProfil,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40B5FF),

                    disabledBackgroundColor: Colors.grey.shade400,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: isLoading
                      ? const SizedBox(
                          width: 25,
                          height: 25,

                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'Enregistrer le profil',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // CHAMP TEXTUEL
  // =========================

  Widget _buildTextField({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required String hint,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          Icon(icon, color: iconColor),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                RichText(
                  text: TextSpan(
                    text: title,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 14,
                    ),

                    children: [
                      if (subtitle != null)
                        TextSpan(
                          text: ' $subtitle',

                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),

                TextField(
                  controller: controller,
                  readOnly: readOnly,
                  onTap: onTap,

                  decoration: InputDecoration(
                    hintText: hint,

                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),

                    border: InputBorder.none,

                    isDense: true,

                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  ),
                ),
              ],
            ),
          ),

          if (readOnly)
            const Icon(Icons.calendar_month, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  // =========================
  // GENRE
  // =========================

  Widget _buildGenderOption({
    required String label,
    required IconData icon,
    required Color iconColor,
    required String value,
  }) {
    final bool selected = genre == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          genre = value;
        });
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

        decoration: BoxDecoration(
          color: selected ? Colors.blue.withOpacity(0.08) : Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade200,
          ),
        ),

        child: Row(
          children: [
            Icon(icon, color: iconColor),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              width: 18,
              height: 18,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: selected ? Colors.blue : Colors.grey.shade400,
                  width: 2,
                ),

                color: selected ? Colors.blue : Colors.transparent,
              ),

              child: selected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
