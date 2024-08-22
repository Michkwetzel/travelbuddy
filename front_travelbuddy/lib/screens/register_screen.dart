import 'package:flutter/material.dart';
import 'package:front_travelbuddy/screens/chatbot_screen.dart';
import 'package:front_travelbuddy/widgets/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/services/auth_service.dart';

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Learn about the world",
                  style: TextStyle(fontSize: 30),
                ),
                Text('By ceating an account you get access to the free version of TravelBuddy'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "email",
                  textAlign: TextAlign.end,
                ),
                Container(
                  width: 500,
                  child: TextField(
                      onChanged: (value) {
                        userEmail = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      )),
                ),
                Text("Password"),
                Container(
                  width: 500,
                  child: TextField(
                      onChanged: (value) {
                        userPassword = value;
                      },
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Provider.of<AuthService>(context, listen: false).createUserWithEmailAndPassword(
                      userEmail: userEmail,
                      userPassword: userPassword,
                      emailVerificationPopUp: () => emailVertificationDialog(context, 'A verification link has been sent to your email.\nPlease verify your account and log in.'),
                    );
                  },
                  child: Text("Create new Account"),
                ),
                SizedBox(
                  height: 10,
                ),
                LineBreak(),
                GoogleSignInButton(
                  onPressed: () async {
                    await Provider.of<AuthService>(context, listen: false).signInWithGoogle();
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    emailVertificationDialog(context, 'A verification link has been sent to your email.\nPlease verify your account and log in.');
                  },
                  child: Text("PopUp screen"),
                )
              ],
            ),  
          ),
        ),
      ),
    );
  }
}
