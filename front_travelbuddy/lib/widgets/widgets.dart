import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LineBreak extends StatelessWidget {
  const LineBreak({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            color: Colors.black,
            height: 1,
          ),
          Padding(
            child: Text('Or'),
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
          Container(
            width: 200,
            color: Colors.black,
            height: 1,
          ),
        ],
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 250,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/icons8-google.svg',
              fit: BoxFit.contain,
              height: 30,
            ),
            SizedBox(
              width: 5,
            ),
            Text('Sign in with Google')
          ],
        ),
      ),
    );
  }
}

Future<void> emailVertificationDialog(BuildContext context, String displayMessage) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Email Verification'),
        content: Text(displayMessage),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

Future<void> passwordResetDialog(BuildContext context, Function(String email) resetPassword) {
  TextEditingController emailController = TextEditingController();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Text('Please enter your email address to reset your password.'),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email address',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Reset Password'),
            onPressed: () {
              String email = emailController.text;
              resetPassword(email);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
