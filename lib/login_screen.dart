import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    }
    return null;
  }

  Future<void> _login() async {
    User? user = await _signInWithGoogle();
    if (user != null) {
      bool isUserAllowed = await _isUserAllowed(user.email!);
      if (isUserAllowed) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Access denied'),
        ));
        await _auth.signOut();
      }
    }
  }

  Future<bool> _isUserAllowed(String email) async {
    // Aquí deberías implementar la lógica para verificar si el usuario pertenece a tu Google Admin
    // Por ejemplo, podrías hacer una llamada a tu backend o verificar una lista de correos permitidos.
    List<String> allowedEmails = ['user1@example.com', 'user2@example.com'];
    return allowedEmails.contains(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Benvingut!')),
      body: Center(
        child: ElevatedButton(
          onPressed: _login,
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
