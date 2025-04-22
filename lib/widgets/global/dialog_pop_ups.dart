import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<void> editChatDescriptionDialogue(BuildContext context, String currentChatDescription, Function(String newDescription) editChatDescription) async {
  TextEditingController textController = TextEditingController(text: currentChatDescription);

  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Rename chat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Text('Enter a new name for the chat:'),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Enter new chat name',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: Text('Rename'),
            onPressed: () {
              String newDescription = textController.text;
              if (newDescription.isNotEmpty && newDescription != currentChatDescription) {
                editChatDescription(newDescription);
              }
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
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
