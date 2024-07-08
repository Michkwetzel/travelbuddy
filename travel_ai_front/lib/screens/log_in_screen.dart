import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;
  String userEmail = '';
  String userPassword = '';

  Future<UserCredential> signInWithGoogle() async {
    print("test");
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
      
    );

    final userCred =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCred);
    return userCred;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: ElevatedButton(
                onPressed: signInWithGoogle,
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                  )),
              Text("Password"),
              TextField(
                  onChanged: (value) {
                    userPassword = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                  )),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    setState(() {
                      showSpinner = true;
                    });
                    final user = await _auth.signInWithEmailAndPassword(
                        email: userEmail, password: userPassword);
                    setState(() {
                      showSpinner = false;
                    });
                    print(user);
                  } on Exception catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    print(e);
                  }
                },
                child: Text("Log in"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (FirebaseAuth.instance.currentUser != null) {
                    print(FirebaseAuth.instance.currentUser?.uid);
                  }
                },
                child: Text("Check"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
