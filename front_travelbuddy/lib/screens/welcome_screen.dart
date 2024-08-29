// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations
// Welcome screen

import 'package:flutter/material.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'package:front_travelbuddy/screens/chatbot_screen.dart';
import 'package:front_travelbuddy/screens/log_in_screen.dart';
import 'package:front_travelbuddy/screens/register_screen.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);

    return Scaffold(
      body: Stack(children: [
        Image.asset('assets/images/_4ed7e042-0cde-4836-bc0d-c155d0c50ba0.jpg', fit: BoxFit.cover),
        Padding(
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
                onPressed: () {
                  userModel.setUser('pQ4L2sJlt0ajudQNgCXFTX7mYoO2');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotScreen()));
                },
                child: Text("ChatBot Screen"),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
