import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestion_de_horarios/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido a la Gestión de Horarios',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _handleGoogleSignIn(context),
              child: const Text('Iniciar sesión con Google'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      print("Iniciando proceso de inicio de sesión con Google");
      
      final User? user = await authService.signInWithGoogle();
      
      if (user == null) {
        print("No se pudo iniciar sesión con Google");
        _showErrorSnackBar(context, "No se pudo iniciar sesión. Por favor, inténtalo de nuevo.");
      } else {
        print("Inicio de sesión exitoso: ${user.email}");
        // Aquí no necesitas navegar manualmente, AuthWrapper se encargará de eso
      }
    } catch (e) {
      print("Error durante el inicio de sesión: $e");
      _showErrorSnackBar(context, "Ocurrió un error durante el inicio de sesión.");
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}