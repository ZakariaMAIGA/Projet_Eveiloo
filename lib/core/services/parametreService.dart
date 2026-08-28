import 'package:shared_preferences/shared_preferences.dart';

class ParametreService {
  static const String _themeKey = 'est_mode_sombre';
  static const String _langueKey = 'code_langue';

  // Charger le thème sauvegardé
  Future<bool> chargerModeSombre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  // Sauvegarder le thème
  Future<void> sauvegarderModeSombre(bool estSombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, estSombre);
  }

  // Charger la langue sauvegardée
  Future<String> chargerCodeLangue() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_langueKey) ?? 'fr';
  }

  // Sauvegarder la langue
  Future<void> sauvegarderCodeLangue(String codeLangue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langueKey, codeLangue);
  }
}