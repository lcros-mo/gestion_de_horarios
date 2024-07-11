import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/admin/directory_v1.dart' as admin;
import 'package:googleapis_auth/auth_io.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile', 'openid']);

  Future<auth.User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final auth.UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> _login() async {
    auth.User? user = await _signInWithGoogle();
    if (user != null) {
      print('User signed in: ${user.email}');
      bool isUserAllowed = await _isUserAllowed(user.email!);
      if (isUserAllowed) {
        print('User is allowed');
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print('User is not allowed');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Access denied'),
        ));
        await _auth.signOut();
      }
    } else {
      print('User sign in failed');
    }
  }

  Future<bool> _isUserAllowed(String email) async {
    final String serviceAccountJson = await rootBundle.loadString('assets/service_account.json');
    final Map<String, dynamic> serviceAccount = json.decode(serviceAccountJson);
    final credentials = ServiceAccountCredentials.fromJson(serviceAccount);
    final authClient = await clientViaServiceAccount(credentials, [
      admin.DirectoryApi.adminDirectoryUserReadonlyScope
    ]);

    final directory = admin.DirectoryApi(authClient);
    final admin.Users users = await directory.users.list(customer: 'my_customer', query: 'email=$email');

    return users.users != null && users.users!.isNotEmpty;
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
