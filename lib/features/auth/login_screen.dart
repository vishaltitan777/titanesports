import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId:
      '72179439708-vt9hsulu9vaic81lt0gtts59gk1eqgdc.apps.googleusercontent.com',
);

      final GoogleSignInAccount? googleUser =
          await googleSignIn.signIn();

      if (googleUser == null) {
        print("User cancelled login");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      print("LOGIN SUCCESS");
      print("CURRENT USER:");
print(FirebaseAuth.instance.currentUser?.uid);
print(FirebaseAuth.instance.currentUser?.email);
      print(userCredential.user?.uid);
      print(userCredential.user?.email);
    } catch (e) {
      print("LOGIN ERROR");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B2D),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            await signInWithGoogle();
          },
          icon: const Icon(Icons.login),
          label: const Text("Sign in with Google"),
        ),
      ),
    );
  }
}