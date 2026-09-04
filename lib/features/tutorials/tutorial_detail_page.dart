import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

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
  ConsumerState<TutorialDetailPage> createState() =>
      _TutorialDetailPageState();
}

class _TutorialDetailPageState extends ConsumerState<TutorialDetailPage> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _dejaComptabilise = false;
  bool _videoIndisponible = false;
  bool _initEnCours = true;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final url = widget.tutoriel.urlVideo;
    if (url.isEmpty) {
      setState(() {
        _videoIndisponible = true;
        _initEnCours = false;
      });
      return;
    }

    try {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio == 0
            ? 16 / 9
            : _videoController!.value.aspectRatio,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFF1E88E5),
          handleColor: const Color(0xFF1E88E5),
        ),
      );

      _videoController!.addListener(_onVideoStateChange);

      if (mounted) setState(() => _initEnCours = false);
    } catch (e) {
      debugPrint('Erreur init vidéo: $e');
      if (mounted) {
        setState(() {
          _videoIndisponible = true;
          _initEnCours = false;
        });
      }
    }
  }

  void _onVideoStateChange() {
    final controller = _videoController;
    if (controller == null) return;

    if (controller.value.isPlaying && !_dejaComptabilise) {
      _comptabiliserProgres();
    }
  }

  Future<void> _comptabiliserProgres() async {
    if (widget.enfantId == null || _dejaComptabilise) return;

    final parentId = ref.read(utilisateurCourantProvider).value?.utilisateurId;
    if (parentId == null) return;

    setState(() => _dejaComptabilise = true);

    await ref.read(journalProgresRepositoryProvider).ajouterEntree(
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

    await ref.read(enfantRepositoryProvider).incrementerProgres(
      parentId, widget.enfantId!, points: 10,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bravo ! Tutoriel complété (+10 pts) ✨')),
      );
    }
  }

  @override
  void dispose() {
    _videoController?.removeListener(_onVideoStateChange);
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
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
              // --- LECTEUR VIDÉO SUPABASE ---
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildVideoPlayer(),
              ),
              const SizedBox(height: 16),
              Text(
                widget.tutoriel.titre,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
              ),
              if (widget.tutoriel.materielIds.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text('Matériel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                jouetsAsync.when(
                  data: (jouets) => Column(
                    children: jouets
                        .map((j) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check_circle, size: 16, color: Color(0xFF1E88E5)),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(j.nom, style: const TextStyle(fontSize: 14))),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: LinearProgressIndicator(),
                  ),
                  error: (e, _) => Text('Erreur matériel: $e', style: const TextStyle(color: Colors.red)),
                ),
              ],
              const SizedBox(height: 24),
              if (widget.enfantId != null)
                Row(
                  children: [
                    Icon(
                      _dejaComptabilise ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: _dejaComptabilise ? Colors.green : Colors.grey.shade400,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _dejaComptabilise ? 'Terminé (+10 pts) ✨' : 'Regarde la vidéo pour valider',
                      style: TextStyle(
                        color: _dejaComptabilise ? Colors.green : Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
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

  Widget _buildVideoPlayer() {
    if (_initEnCours) {
      return Container(
        width: double.infinity,
        height: 220,
        color: Colors.grey.shade200,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_videoIndisponible || _chewieController == null) {
      return Container(
        width: double.infinity,
        height: 220,
        color: Colors.grey.shade200,
        child: const Center(child: Text('Vidéo indisponible')),
      );
    }

    return AspectRatio(
      aspectRatio: _chewieController!.aspectRatio ?? 16 / 9,
      child: Chewie(controller: _chewieController!),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}