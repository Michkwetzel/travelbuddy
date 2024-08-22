// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations
// Welcome screen

import 'package:flutter/material.dart';
import 'package:front_travelbuddy/screens/chatbot_screen.dart';
import 'package:front_travelbuddy/screens/log_in_screen.dart';
import 'package:front_travelbuddy/screens/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text("The world is a beautifull place", style: TextStyle(fontSize: 25))),
            Text('Lets learn about it'),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen())),
              child: Text("Log in"),
            ),
            SizedBox(
              height: 5,
            ),
            ElevatedButton(
              style: ButtonStyle(),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen())),
              child: Text("Sign up"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotScreen())),
              child: Text("ChatBot Screen"),
            )
          ],
        ),
      ),
    );
  }
}
