import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'features/orders/orders_page.dart';
import 'features/orders/checkout_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eveiloo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF3D9BE9),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      // TODO: remplacer par l'écran d'authentification (features/auth)
      // une fois celui-ci implémenté, et récupérer le vrai utilisateurId
      // via AuthService().utilisateurFirebase!.uid.
      home: const _DemoHomePage(),
    );
  }
}

/// Point d'entrée temporaire, le temps que l'écran d'authentification et
/// le routeur (go_router) soient branchés. Permet de tester directement
/// les écrans "Paiement" et "Mes Commandes".
class _DemoHomePage extends StatelessWidget {
  const _DemoHomePage();

  static const String _utilisateurIdDemo = 'demo-user';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CheckoutPage(
                        utilisateurId: _utilisateurIdDemo,
                        montant: 27000,
                        adresseLivraison: 'Bamako, Mali',
                      ),
                    ),
                  ),
                  child: const Text('Tester le paiement'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OrdersPage(
                        utilisateurId: _utilisateurIdDemo,
                      ),
                    ),
                  ),
                  child: const Text('Voir mes commandes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
