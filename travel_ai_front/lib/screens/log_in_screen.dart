import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:travel_ai_front/services/auth_service.dart';
import 'package:travel_ai_front/state/spinner.dart';
import 'package:travel_ai_front/state/user_model.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  String userEmail = '';
  String userPassword = '';

  @override
  Widget build(BuildContext context) {
    //provide spinner callback to authService

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<Spinner>(context).spinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: ElevatedButton(
                onPressed: Provider.of<AuthService>(context, listen: false).signInWithGoogle,
                child: Text("Google Log in"),
              )),
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                  )),
              Text("Password"),
              TextField(
                  onChanged: (value) {
                    userPassword = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                  )),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  //Sign in with username and Password
                  Provider.of<AuthService>(context, listen: false).signInWithEmailAndPassword(userEmail, userPassword);
                },
                child: Text("Log in"),
              ),
              Consumer<UserModel>(builder: (context, userModel, child) {
                return Text(userModel.user);
              }),
              FloatingActionButton(onPressed: Provider.of<Spinner>(context, listen: false).showSpinner)
            ],
          ),
        ),
      ),
    );
  }
}
