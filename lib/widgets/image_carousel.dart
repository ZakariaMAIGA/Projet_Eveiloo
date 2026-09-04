import 'package:flutter/material.dart';

import '../core/constants/AppColors.dart';

/// Carrousel d'images sur fond bleu clair arrondi, avec indicateurs à
/// points et flèche "suivant", tel que sur l'écran de détail d'un jouet.
///
/// Reçoit une liste de [Widget] (typiquement des `Image.network` ou
/// `Image.asset`) plutôt que des URLs, pour rester agnostique de la source
/// des images.
class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    super.key,
    required this.images,
    this.height = 320,
  });

  final List<Widget> images;
  final double height;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToNext() {
    if (_currentPage < widget.images.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            height: widget.height,
            color: AppColors.lightBlueBackground,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.images.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) => widget.images[index],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(widget.images.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? AppColors.primary : AppColors.white,
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
              );
            }),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: _goToNext,
              child: const Icon(
                Icons.chevron_right,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
