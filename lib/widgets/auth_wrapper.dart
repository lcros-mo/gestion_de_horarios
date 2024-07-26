import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestion_de_horarios/screens/home_screen.dart';
import 'package:gestion_de_horarios/screens/login_screen.dart';
import 'package:gestion_de_horarios/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            print('Usuario no autenticado, mostrando LoginScreen');
            return const LoginScreen();
          } else {
            return FutureBuilder<bool>(
              future: authService.isUserAuthorized(user.email!),
              builder: (_, AsyncSnapshot<bool> authSnapshot) {
                if (authSnapshot.connectionState == ConnectionState.done) {
                  if (authSnapshot.data == true) {
                    print('Usuario autenticado y autorizado, mostrando HomeScreen');
                    return const HomeScreen();
                  } else {
                    print('Usuario autenticado pero no autorizado, mostrando LoginScreen');
                    // Aquí podrías mostrar un mensaje de error o cerrar la sesión
                    authService.signOut();
                    return const LoginScreen();
                  }
                }
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              },
            );
          }
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}