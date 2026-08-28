import 'package:flutter/material.dart';

class EnteteProfil extends StatelessWidget {
  final String nomEnfant;
  final String urlAvatar;

  const EnteteProfil({
    super.key,
    required this.nomEnfant,
    required this.urlAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8F9BBA).withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF9A9E).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: const Color(0xFFF0F4FC),
                  backgroundImage: urlAvatar.isNotEmpty
                      ? NetworkImage(urlAvatar)
                      : null,
                  child: urlAvatar.isEmpty
                      ? const Icon(
                          Icons.face_retouching_natural_rounded,
                          size: 45,
                          color: Color(0xFF6C63FF),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Salut, $nomEnfant !',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1E2C),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Prêt(e) pour une nouvelle aventure ?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE81E63),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
