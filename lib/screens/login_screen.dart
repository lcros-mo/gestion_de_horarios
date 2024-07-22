import 'package:flutter/material.dart';
import 'package:gestion_de_horarios/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Future<void> _login(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final user = await authService.signInWithGoogle();
      if (user != null) {
        final isAuthorized = await authService.isUserAuthorized(user.email!);
        if (isAuthorized) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access denied')),
          );
          await authService.signOut();
        }
      }
    } catch (e) {
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Benvingut!')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _login(context),
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
