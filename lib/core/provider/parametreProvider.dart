import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

// =============================================================================
// 1. PROVIDER THÈME (Persistance SharedPreferences)
// =============================================================================
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});



class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _chargerTheme();
  }

  Future<void> _chargerTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final estSombre = prefs.getBool('est_mode_sombre') ?? false;
    state = estSombre ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> basculerTheme(bool estSombre) async {
    state = estSombre ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('est_mode_sombre', estSombre);
  }
}

// =============================================================================
// 2. PROVIDER LANGUE (Persistance SharedPreferences)
// =============================================================================
final langueProvider = StateNotifierProvider<LangueNotifier, Locale>((ref) {
  return LangueNotifier();
});

class LangueNotifier extends StateNotifier<Locale> {
  // Un seul constructeur propre avec appel au super et corps de méthode
  LangueNotifier() : super(const Locale('fr')) {
    _chargerLangue();
  }

  Future<void> _chargerLangue() async {
    final prefs = await SharedPreferences.getInstance();
    final codeLangue = prefs.getString('code_langue') ?? 'fr';
    state = Locale(codeLangue);
  }

  Future<void> changerLangue(String codeLangue) async {
    state = Locale(codeLangue);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('code_langue', codeLangue);
  }
}

// =============================================================================
// 3. PROVIDER NOTIFICATIONS (Persistance SharedPreferences)
// =============================================================================
final notificationProvider = StateNotifierProvider<NotificationNotifier, bool>((ref) {
  return NotificationNotifier();
});

class NotificationNotifier extends StateNotifier<bool> {
  NotificationNotifier() : super(true) {
    _chargerNotifications();
  }

  Future<void> _chargerNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('notifications_actives') ?? true;
  }

  Future<void> basculerNotification(bool active) async {
    state = active;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_actives', active);
  }
}