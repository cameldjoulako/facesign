import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

const Color bgColor = Color(0xFF4285F4);

class Authentication {
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: bgColor,
      content: Text(
        content,
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

// Connexion avec Google
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Déclenchement du flux d'authentification
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    // recuperation des détails d'autorisation de la demande de connexion
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // création d'un nouvel identifiant
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        //connexion et renvoi de l'identifiant de l'utilisateur dans user
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Le compte existe déjà avec un identifiant différent',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content:
                  "Une erreur s'est produite lors de l'accès aux informations d'identification. Réessayer.",
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content:
                "Une erreur s'est produite lors de l'utilisation de Google Sign-In. Réessayer.",
          ),
        );
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Erreur de déconnexion. Réessayer.',
        ),
      );
    }
  }
}
