import 'package:flutter/material.dart';
import 'package:eveiloo_enfant/features/favoris/favoris_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eveiloo Enfant',
      debugShowCheckedModeBanner: false, // Enlève la bannière rouge "Debug"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Chargement de votre page avec des données de test
      home: const FavorisScreen(
        enfantId: "enfant_test_123",
        avatarUrl: "https://placeholder.com",
      ),
    );
  }
}
