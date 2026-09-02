import 'package:flutter/material.dart';

class ActivityCardPremium extends StatefulWidget {
  final String urlAvatar;
  final String titre;
  final String description;
  final String tempsEcoule;
  final VoidCallback onTap;

  const ActivityCardPremium({
    super.key,
    required this.urlAvatar,
    required this.titre,
    required this.description,
    required this.tempsEcoule,
    required this.onTap,
  });

  @override
  State<ActivityCardPremium> createState() => _ActivityCardPremiumState();
}

class _ActivityCardPremiumState extends State<ActivityCardPremium> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFF6C63FF).withOpacity(0.30)
                  : const Color(0xFF8F9BBA).withOpacity(0.08),
              blurRadius: _isHovered ? 28 : 10,
              spreadRadius: _isHovered ? 3 : 0,
              offset: Offset(0, _isHovered ? 10 : 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: widget.onTap,
            splashColor: const Color(0xFFF0F4FC),
            highlightColor: const Color(0xFFF9FAFC),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB19CD9), Color(0xFFF6C9FF)],
                      ),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFFB19CD9,
                                ).withOpacity(0.65),
                                blurRadius: 18,
                                spreadRadius: 3,
                              ),
                            ]
                          : [],
                    ),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      backgroundImage: widget.urlAvatar.isNotEmpty
                          ? NetworkImage(widget.urlAvatar)
                          : null,
                      child: widget.urlAvatar.isEmpty
                          ? const Icon(
                              Icons.star_rounded,
                              color: Colors.purpleAccent,
                              size: 30,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.titre,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _isHovered ? 17 : 16,
                            color: const Color(0xFF1E1E2C),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.tempsEcoule.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 13,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.tempsEcoule,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isHovered
                          ? const Color(0xFF6C63FF).withOpacity(0.12)
                          : const Color(0xFFF0F4FC),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF6C63FF,
                                ).withOpacity(0.55),
                                blurRadius: 14,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: const Color(0xFF6C63FF),
                      size: _isHovered ? 31 : 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
