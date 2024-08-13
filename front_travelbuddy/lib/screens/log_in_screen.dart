import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:front_travelbuddy/screens/chatbot_screen.dart';
import 'package:front_travelbuddy/services/auth_service.dart';
import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'package:front_travelbuddy/screens/user_data_capture_screen.dart';

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
                onPressed: () {
                  Provider.of<AuthService>(context, listen: false).signInWithGoogle(() => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotScreen())));
                },
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
                  await Provider.of<AuthService>(context, listen: false)
                      .signInWithEmailAndPassword(userEmail, userPassword, () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotScreen())));
                },
                child: Text("Log in"),
              ),
              Consumer<UserModel>(builder: (context, userModel, child) {
                return Text(userModel.currentUser);
              }),
              TextButton(
                onPressed: () => {Provider.of<AuthService>(context, listen: false).signOut()},
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
                child: Text(
                  "Sign out",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => {},
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
                child: Text(
                  "Send get request",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => (Navigator.push(context, MaterialPageRoute(builder: (context) => UserDataCaptureScreen()))),
                child: Text("User data capture"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
