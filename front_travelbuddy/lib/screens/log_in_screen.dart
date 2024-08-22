import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:front_travelbuddy/screens/chatbot_screen.dart';
import 'package:front_travelbuddy/services/auth_service.dart';
import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'package:front_travelbuddy/services/http_service.dart';
import 'package:front_travelbuddy/widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  String userEmail = '';
  String userPassword = '';
  final http = HttpService();

  @override
  Widget build(BuildContext context) {
    //provide spinner callback to authService

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => passwordResetDialog(
          context,
          (email) => Provider.of<AuthService>(context, listen: false).resetPassword(userEmail: email),
        ),
        label: Text("Reset Password"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<Spinner>(context).spinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome back adventurer",
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "email",
                  textAlign: TextAlign.end,
                ),
                SizedBox(
                  width: 500,
                  child: TextField(
                      onChanged: (value) {
                        userEmail = value;
                      },
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    //Sign in with username and Password
                    await Provider.of<AuthService>(context, listen: false).signInWithEmailAndPassword(
                      userEmail: userEmail,
                      userPassword: userPassword,
                      emailVerificationPopUp: () => emailVertificationDialog(context, 'Another verification link has been sent to your email.\nPlease verify your account and log in.'),
                      nextScreenCall: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotScreen())),
                    );
                  },
                  child: Text("Log in"),
                ),
                SizedBox(
                  width: 20,
                ),
                LineBreak(),
                GoogleSignInButton(
                  onPressed: () async {
                    await Provider.of<AuthService>(context, listen: false).signInWithGoogle(
                      nextScreenCall: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotScreen())),
                    );
                  },
                ) // Consumer<UserModel>(builder: (context, userModel, child) {
                //   return Text(userModel.currentUser);
                // }),
                // TextButton(
                //   onPressed: () => {Provider.of<AuthService>(context, listen: false).signOut()},
                //   style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
                //   child: Text(
                //     "Sign out",
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
                // TextButton(
                //   onPressed: () async {
                //     String path = 'write_to_db';
                //     Map<String, dynamic> request = {
                //       'collection': 'chats',
                //       'data': {'message': 'Hi', 'name': 'WoWO'}
                //     };
                //     try {
                //       final responseBody = await http.postRequest(path: path, request: request);
                //       print('Response: $responseBody'); // Or handle the response as needed
                //     } catch (e) {
                //       print('Error during POST request: $e');
                //     }
                //   },
                //   style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
                //   child: Text(
                //     "Send get request",
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
                // TextButton(
                //   onPressed: () => (),
                //   child: Text("User data capture"),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
