import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/provider/auth_provider.dart';
import '../../core/provider/enfant_provider.dart';
import '../../core/provider/journal_progres_provider.dart';
import '../../core/provider/tutoriel_provider.dart';
import '../../models/TutorielModel.dart';
import '../../models/journal_progres_model.dart';

class TutorialDetailPage extends ConsumerStatefulWidget {
  final TutorielModel tutoriel;
  final String? enfantId; // null = parent (non comptabilisé)

  const TutorialDetailPage({
    super.key,
    required this.tutoriel,
    required this.enfantId,
  });

  @override
  ConsumerState<TutorialDetailPage> createState() => _TutorialDetailPageState();
}

class _TutorialDetailPageState extends ConsumerState<TutorialDetailPage> {
  bool _dejaComptabilise = false;

  Future<void> _regarder() async {
    final videoUri = Uri.tryParse(widget.tutoriel.urlVideo);
    if (videoUri == null || !videoUri.hasScheme || !videoUri.hasAbsolutePath) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aucune vidéo disponible pour ce tutoriel.'),
          ),
        );
      }
      return;
    }

    final ouvert = await launchUrl(
      videoUri,
      mode: LaunchMode.externalApplication,
    );
    if (!ouvert) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir la vidéo.')),
        );
      }
      return;
    }

    // Comptabilisation uniquement en mode enfant.
    if (widget.enfantId == null || _dejaComptabilise) return;

    final parentId = ref.read(utilisateurCourantProvider).value?.utilisateurId;
    if (parentId == null) return;

    setState(() => _dejaComptabilise = true);

    await ref
        .read(journalProgresRepositoryProvider)
        .ajouterEntree(
          JournalProgresModel(
            journalId: '',
            utilisateurId: parentId,
            enfantId: widget.enfantId!,
            elementId: widget.tutoriel.tutorielId,
            typeElement: TypeElementProgres.tutoriel,
            titre: widget.tutoriel.titre,
            pointsGagnes: 10,
            dateRealisation: DateTime.now(),
          ),
        );

    await ref
        .read(enfantRepositoryProvider)
        .incrementerProgres(parentId, widget.enfantId!, points: 10);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bravo ! Tutoriel complété (+10 pts) ✨')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final jouetsAsync = ref.watch(
      jouetsTutorielProvider(widget.tutoriel.materielIds),
    );
    final ageText = '${widget.tutoriel.ageMin}-${widget.tutoriel.ageMax} ans';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    widget.tutoriel.urlImage.isNotEmpty
                        ? Image.network(
                            widget.tutoriel.urlImage,
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: double.infinity,
                                  height: 220,
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.image,
                                    size: 46,
                                    color: Colors.grey,
                                  ),
                                ),
                          )
                        : Container(
                            width: double.infinity,
                            height: 220,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image,
                              size: 46,
                              color: Colors.grey,
                            ),
                          ),
                    GestureDetector(
                      onTap: _regarder,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 36,
                          color: Color(0xFF1E88E5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.tutoriel.titre,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip(ageText),
                  if (widget.tutoriel.categorie.isNotEmpty)
                    _chip(widget.tutoriel.categorie),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.tutoriel.description,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              if (widget.tutoriel.materielIds.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  'Matériel',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                jouetsAsync.when(
                  data: (jouets) => Column(
                    children: jouets
                        .map(
                          (j) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: Color(0xFF1E88E5),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    j.nom,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: LinearProgressIndicator(),
                  ),
                  error: (e, _) => Text(
                    'Erreur matériel: $e',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _regarder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF87CEFF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.enfantId != null && _dejaComptabilise
                            ? 'Terminé ✓'
                            : 'Regarder',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
