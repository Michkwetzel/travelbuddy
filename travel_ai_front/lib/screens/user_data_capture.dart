import 'package:flutter/material.dart';

class userDataCaptureScreen extends StatefulWidget {
  const userDataCaptureScreen({super.key});

  @override
  State<userDataCaptureScreen> createState() => _userDataCaptureScreenState();
}

class _userDataCaptureScreenState extends State<userDataCaptureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () => {print("Save data")},
        backgroundColor: Colors.white,
        child: Icon(
          Icons.check,
          color: Colors.green,
          size: 40,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          DataField(text: "Name"),
          DataField(text: "Surname"),
          DataField(text: "Passport"),
          DataField(text: "Destination"),
          DataField(text: "Age"),
          DataField(text: "Travel budget")
        ],
      ),
    );
  }
}

class DataField extends StatelessWidget {
  const DataField({
    super.key,
    required this.text,
  });

  final String text;

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
