import 'package:flutter/material.dart';

class LineBreak extends StatelessWidget {
  final String colour;

  const LineBreak({this.colour = 'white', super.key});

  @override
  Widget build(BuildContext context) {
    Color paintColour;
    if (colour == 'white') {
      paintColour = Colors.white;
    } else {
      paintColour = Colors.black;
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 200, // Set maximum width
              ),
              color: paintColour,
              height: 1,
            ),
          ),
          Padding(
            child: Text(
              'Or',
              style: TextStyle(color: paintColour),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 200,
              ),
              color: paintColour,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
