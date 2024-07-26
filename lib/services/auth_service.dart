import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final String _baseUrl = 'http://10.0.2.2:3000';

  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> signInWithGoogle() async {
  try {
    print("Iniciando proceso de inicio de sesión con Google");
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      print("El usuario canceló el inicio de sesión con Google");
      return null;
    }

    print("Usuario de Google obtenido: ${googleUser.email}");
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    print("Autenticando con Firebase");
    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    print("Usuario autenticado con Firebase: ${userCredential.user?.email}");

    return userCredential.user;
  } catch (e) {
    print("Error durante el inicio de sesión con Google: $e");
    return null;
  }
}

  Future<bool> isUserAuthorized(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/verifyUser'),
        body: json.encode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['isAllowed'] ?? false;
      } else {
        print('Error de servidor: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al verificar la autorización del usuario: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}