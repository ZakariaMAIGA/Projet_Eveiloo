
import 'package:eveiloo_enfant/routes/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error, stackTrace) {
    debugPrint('Erreur Firebase : $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Facteur d'échelle maximal appliqué au texte, quelle que soit la
  /// configuration système du téléphone. Par défaut Android autorise
  /// jusqu'à 2.0 (Paramètres > Affichage > Taille de police), ce qui
  /// donnait l'impression d'écrans "zoomés" sur un vrai téléphone.
  static const double _maxTextScaleFactor = 1.2;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Éveiloo Enfant',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Plafonne l'échelle de texte du système Android : sans cela, tout le
      // texte est multiplié par le réglage "Taille de police" du téléphone
      // (souvent 110-130 % sur un vrai téléphone), d'où l'effet zoomé.
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final systemScale = mediaQuery.textScaler.scale(100) / 100;
        final clampedScale =
            systemScale.clamp(0.9, _maxTextScaleFactor).toDouble();
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(clampedScale),
          ),
          child: child!,
        );
      },
      routerConfig: AppRouter.router,
    );
  }
}
