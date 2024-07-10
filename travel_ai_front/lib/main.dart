// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations
// Welcome screen
import 'package:firebase_core/firebase_core.dart';
import 'package:travel_ai_front/services/auth_service.dart';
import 'package:travel_ai_front/state/spinner.dart';
import 'package:travel_ai_front/state/user_model.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:travel_ai_front/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => Spinner()),
        Provider(create: (context) => AuthService(spinner: context.read<Spinner>())),
      ],
      child: MaterialApp(
        home: WelcomeScreen(),
      ),
    ),
  );
}
