import 'package:flutter/material.dart';
import 'package:gestion_de_horarios/services/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gestion_de_horarios/services/auth_service.dart';
import 'package:gestion_de_horarios/utils/colors.dart';
import 'package:gestion_de_horarios/widgets/auth_wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'Employee Time Tracking',
        theme: ThemeData(
          primarySwatch: customColor,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
