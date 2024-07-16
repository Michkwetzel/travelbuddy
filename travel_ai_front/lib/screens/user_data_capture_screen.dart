import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_ai_front/change_notifiers/user_data_capture_notifier.dart';
import 'package:travel_ai_front/change_notifiers/user_model.dart';
import 'package:travel_ai_front/services/db_service.dart';

class UserDataCaptureScreen extends StatefulWidget {
  const UserDataCaptureScreen({super.key});

  @override
  State<UserDataCaptureScreen> createState() => _UserDataCaptureScreenState();
}

class _UserDataCaptureScreenState extends State<UserDataCaptureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbService = DbService();

  @override
  Widget build(BuildContext context) {
    final userDataNotifier = Provider.of<UserDataCaptureNotifier>(context, listen: false);
    final signedInUser = Provider.of<UserModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.purple[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // If the validation rules passed
            _formKey.currentState!.save(); // Save the current state of the text fields
            final userData = userDataNotifier.userData;
            print(await _dbService.writeToDB(collection: 'users',data:  userData.toMap(), docId: signedInUser.currentUser));
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
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            DataField(
              text: "Name",
              onSaved: (value) => userDataNotifier.updateUserDataCapture("name", value!),
            ),
            DataField(
              text: "Surname",
              onSaved: (value) => userDataNotifier.updateUserDataCapture("surname", value!),
            ),
            DataField(
              text: "Passport",
              onSaved: (value) => userDataNotifier.updateUserDataCapture("passport", value!),
            ),
            DataField(
              text: "Destination",
              onSaved: (value) => userDataNotifier.updateUserDataCapture("destination", value!),
            ),
            DataField(
              text: "Age",
              onSaved: (value) => userDataNotifier.updateUserDataCapture("age", value!),
            ),
            DataField(
              text: "Travel budget",
              onSaved: (value) => userDataNotifier.updateUserDataCapture("travelBudget", value!),
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
  final void Function(String?)? onSaved;

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
            child: TextFormField(
              onSaved: onSaved,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          )
        ],
      ),
    );
  }
}
