import 'package:eveiloo_enfant/core/constants/AppSpacing.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String? photoUrl;

  const ProfileHeader({super.key, this.name = 'Utilisateur', this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color(0xFFD9F7FF),
          backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
              ? NetworkImage(photoUrl!)
              : null,
          child: photoUrl == null || photoUrl!.isEmpty
              ? const Icon(Icons.person, size: 50, color: Colors.pinkAccent)
              : null,
        ),

        AppSpacing.verticalGapMd,

        Text(
          name,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
