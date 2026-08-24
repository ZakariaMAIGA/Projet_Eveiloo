import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;

import '../../models/utilisateur.dart';
import '../../repository/utilisateurRepository.dart';

class AuthService {
  AuthService({
    FirebaseAuth? firebaseAuth,
    UtilisateurRepository? utilisateurRepository,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance,
       _utilisateurRepository =
           utilisateurRepository ?? UtilisateurRepository();

  final FirebaseAuth _auth;
  final UtilisateurRepository _utilisateurRepository;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get utilisateurFirebase => _auth.currentUser;

  Future<void> inscription({
    required String nom,
    required String prenom,
    required String courriel,
    required String motDePasse,
    String? telephone,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: courriel.trim(),
      password: motDePasse,
    );

    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw Exception('La création du compte a échoué.');
    }

    await firebaseUser.updateDisplayName('$prenom $nom');

    final utilisateur = UtilisateurModel(
      utilisateurId: firebaseUser.uid,
      nom: nom.trim(),
      prenom: prenom.trim(),
      courriel: courriel.trim().toLowerCase(),
      telephone: telephone?.trim() ?? '',
      role: 'parent',
      dateCreation: DateTime.now(),
    );

    await _utilisateurRepository.creer(utilisateur);
  }

  Future<void> connexion({
    required String courriel,
    required String motDePasse,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: courriel.trim(),
      password: motDePasse,
    );

    final firebaseUser = credential.user;

    if (firebaseUser != null) {
      await _utilisateurRepository.mettreAJourDerniereConnexion(
        firebaseUser.uid,
      );
    }
  }

  Future<void> deconnexion() {
    return _auth.signOut();
  }

  Future<void> reinitialiserMotDePasse(String courriel) {
    return _auth.sendPasswordResetEmail(email: courriel.trim());
  }
}
