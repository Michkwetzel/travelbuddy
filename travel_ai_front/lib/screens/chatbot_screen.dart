import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_ai_front/change_notifiers/user_model.dart';
import 'package:travel_ai_front/services/messaging_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  bool isDrawerOpen = false;
  String userMessage = '';
  final messageTextController = TextEditingController();
  late UserModel userModel;
  late MessagingService messageService;

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    userModel = Provider.of<UserModel>(context);
    messageService = MessagingService(userModel: userModel);

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
                ListTile(title: Text("Chat 1", softWrap: false)),
                ListTile(title: Text("Chat 2", softWrap: false)),
                ListTile(title: Text("Chat 3", softWrap: false)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              //Main Chat Tab
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      print(messageService.getMessageStream(chatRoomID: '1'));
                    },
                    child: Text("Get Stream")),
                StreamBuilder(
                    stream: messageService.getMessageStream(chatRoomID: '1'),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }
                      final messages = snapshot.data!.docs.reversed;
                      List<MessageBuble> messageWidgets = [];
                      for (var message in messages) {
                        Map<String, dynamic> data = message.data() as Map<String, dynamic>;
                        final text = data['message'];
                        final role = data['role'];
                        final messageWidget = MessageBuble(message: text, sender: role);
                        messageWidgets.add(messageWidget);
                      }
                      return Expanded(
                        child: ListView(
                          reverse: true,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          children: messageWidgets,
                        ),
                      );
                    }),
                Column(children: [
                  Container(
                    child: Row(
                      // Bottom Textfield
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                        ),
                        Expanded(
                          child: TextField(
                            controller: messageTextController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              hintText: 'Type your message here...',
                              border: OutlineInputBorder(borderSide: BorderSide(), borderRadius: BorderRadius.circular(20)),
                            ),
                            onChanged: (value) {
                              userMessage = value;
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              messageTextController.clear();
                              String response = await messageService.sendMessage(chatRoomID: 'Chat1', userMessage: userMessage);
                              print(response);
                            },
                            icon: Icon(Icons.send))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ])
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBuble extends StatelessWidget {
  const MessageBuble({required this.message, required this.sender, super.key});

  final String message;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 10, color: Colors.black),
          ),
          Material(
            borderRadius: BorderRadius.circular(20),
            elevation: 7,
            color: Colors.blue,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                )),
          ),
        ],
      ),
    );
  }
}
