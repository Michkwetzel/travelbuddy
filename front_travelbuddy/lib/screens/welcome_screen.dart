// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations
// Welcome screen

import 'package:flutter/material.dart';
import 'package:front_travelbuddy/screens/log_in_screen.dart';
import 'package:front_travelbuddy/screens/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(children: [
        
        Image.asset('assets/images/_4ed7e042-0cde-4836-bc0d-c155d0c50ba0.jpg', fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 250),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("The world is a beautifull place", style: TextStyle(fontSize: 25, color: Colors.white)),
                  Text('Lets learn about it', style: TextStyle(color: Colors.white)),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen())),
                    child: Text("Log in",),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen())),
                    child: Text("Sign up"),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
