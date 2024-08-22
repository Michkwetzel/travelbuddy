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

Future<void> widgetDialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email Verification'),
          content: Text('A verification link has been sent to your email.\nPlease verify your account and log in.'),
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