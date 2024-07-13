import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_ai_front/change_notifiers/user_data_capture_notifier.dart';

class userDataCaptureScreen extends StatefulWidget {
  const userDataCaptureScreen({super.key});

  @override
  State<userDataCaptureScreen> createState() => _userDataCaptureScreenState();
}

class _userDataCaptureScreenState extends State<userDataCaptureScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userDataNotifier = Provider.of<UserDataCaptureNotifier>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.purple[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            final userData = userDataNotifier.userData;
            print(userData.toString());
          }
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.check,
          color: Colors.green,
          size: 40,
        ),
      ),
      body: Form(
        key: _formKey, // Add this line

        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            DataField(
              text: "Name",
              onSaved: (value) => userDataNotifier.updateUserDataCapture("Name", value!),
            ),
            DataField(
              text: "Surname",
              onSaved: (value) => userDataNotifier.updateUserDataCapture("Surname", value!),
            ),
            DataField(
              text: "Passport",
              onSaved: (value) => userDataNotifier.updateUserDataCapture("Passport", value!),
            ),
            DataField(
              text: "Destination",
              onSaved: (value) => userDataNotifier.updateUserDataCapture("Destination", value!),
            ),
            DataField(
              text: "Age",
              onSaved: (value) => userDataNotifier.updateUserDataCapture("Age", value!),
            ),
            DataField(
              text: "Travel budget",
              onSaved: (value) => userDataNotifier.updateUserDataCapture("Travel budget", value!),
            )
          ],
        ),
      ),
    );
  }
}

class DataField extends StatelessWidget {
  const DataField({super.key, required this.text, required this.onSaved});

  final String text;
  final void Function(String?)? onSaved; // Add this line

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(text),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextField(onChanged: (value) => {}, decoration: InputDecoration(border: OutlineInputBorder())),
          )
        ],
      ),
    );
  }
}
