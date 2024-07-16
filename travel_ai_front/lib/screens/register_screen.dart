import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:travel_ai_front/change_notifiers/spinner.dart';
import 'package:travel_ai_front/screens/user_data_capture_screen.dart';
import 'package:travel_ai_front/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String userEmail = '';
  String userPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<Spinner>(context).spinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Register",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "email",
                textAlign: TextAlign.end,
              ),
              TextField(
                  onChanged: (value) {
                    userEmail = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                  )),
              Text("Password"),
              TextField(
                  onChanged: (value) {
                    userPassword = value;
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                  )),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  Provider.of<AuthService>(context, listen: false).createUserWithEmailAndPassword(
                      userEmail: userEmail, userPassword: userPassword, nextScreenCall: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserDataCaptureScreen())));
                },
                child: Text("Create new Account"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
