import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageBuble extends StatelessWidget {
  MessageBuble({required this.message, required this.sender, super.key});
  String message;
  final String sender;

  @override
  Widget build(BuildContext context) {
    var crossAxisAlignment = CrossAxisAlignment.start;
    var edgeInsets = EdgeInsets.symmetric(vertical: 10);
    var bubbleColor = Colors.white;
    var fontWeight = FontWeight.w400;

    if (sender == 'user') {
      crossAxisAlignment = CrossAxisAlignment.end;
      edgeInsets = EdgeInsets.only(top: 10, bottom: 10, left: 100);
      bubbleColor = Colors.lightBlue[100]!;
      fontWeight = FontWeight.w500;
    }

    return Padding(
      padding: edgeInsets,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
          Material(
            borderRadius: BorderRadius.circular(20),
            elevation: 7,
            color: bubbleColor,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: MarkdownBody(
                data: message,
                styleSheet: MarkdownStyleSheet(
                    p: TextStyle(color: Colors.black, fontSize: 16, fontWeight: fontWeight, fontFamily: 'Montserrat'),
                    strong: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Montserrat')),
                selectable: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
