import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_ai_front/change_notifiers/side_panel_state.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  bool isDrawerOpen = false;

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Travel Buddy"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: toggleDrawer,
        ),
      ),
      body: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            width: isDrawerOpen ? 250.0 : 0.0,
            child: ListView(
              children: [
                ListTile(
                    title: Text(
                  "Chat 1",
                  softWrap: false,
                )),
                ListTile(
                    title: Text(
                  "Chat 2",
                  softWrap: false,
                )),
                ListTile(
                    title: Text(
                  "Chat 3",
                  softWrap: false,
                )),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blue,
              child: Center(
                child: Row(
                  children: [
                    TextButton(
                      child: Text("Test"),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
