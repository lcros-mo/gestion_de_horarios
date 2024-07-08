import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  void _login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_username == 'admin' && _password == 'admin') {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid credentials'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Benvingut!')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Usuari',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _username = value!,
                  validator: (value) => value!.isEmpty ? 'Introdueix Usuari' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Contrasenya',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onSaved: (value) => _password = value!,
                  validator: (value) => value!.isEmpty ? 'Introdueix Contrasenya' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Acceptar'),
                ),
              ],
          ),
        ),
      ),
    );
  }
}

