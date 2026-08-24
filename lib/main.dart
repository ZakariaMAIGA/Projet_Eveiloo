import 'package:eveiloo_enfant/features/activities/activities_page.dart';
import 'package:eveiloo_enfant/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Eveiloo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2A9D8F)),
          scaffoldBackgroundColor: const Color(0xFFF7FAF8),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF7FAF8),
            foregroundColor: Color(0xFF173B35),
            elevation: 0,
          ),
        ),
        home: const ActivitiesPage(),
      ),
    );
  }
}
