import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialsign/pages/profile.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

const Color bgColor = Color.fromARGB(255, 7, 91, 226);

class Authentication {
  //initialisation firebase et redirection au cas ou l'utilisateur est deja connecté
  static Future<FirebaseApp> initApp({required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print("Utilisateur Connecté: ${user.email!}");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Profile(user: user)),
      );
    }

    return firebaseApp;
  }

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

// Connexion avec Facebook
  static Future<User?> signInWithFacebook( 
      {required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final LoginResult facebookSignInAccount =
        await FacebookAuth.instance.login();

    if (facebookSignInAccount.status == LoginStatus.success) {
      final OAuthCredential credential = FacebookAuthProvider.credential(
          facebookSignInAccount.accessToken!.token);

      try {
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
                "Une erreur s'est produite lors de l'utilisation de Facebook Sign-In. Réessayer.",
          ),
        );
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Erreur de déconnexion. Réessayer.',
        ),
      );
    }
  }
}
