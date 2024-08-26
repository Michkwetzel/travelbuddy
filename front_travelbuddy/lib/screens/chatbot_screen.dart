import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front_travelbuddy/change_notifiers/fire_base_stream_provider.dart';
import 'package:front_travelbuddy/services/back_end_service.dart';
import 'package:provider/provider.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';

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
  late BackEndService backEndService;
  late FireStoreStreamProvider streamProvider;

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    userModel = Provider.of<UserModel>(context);
    backEndService = Provider.of<BackEndService>(context);
    streamProvider = Provider.of<FireStoreStreamProvider>(context, listen: false);
    streamProvider.initializeMessageStream('1');
    streamProvider.initializeChatRoomStream();

  
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
            child: Column(
              children: [
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Create new chat',
                      softWrap: false,
                    )),
                Flexible(
                  child: StreamBuilder (
                      stream: streamProvider.chatRoomStream,
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text("Loading");
                        } else {
                          List<TextButton> chatTiles = [];
                          final chats = snapshot.data!.docs;
                          for (var chat in chats) {
                            // Maybe here is overkill in code
                            Map<String, dynamic> data = chat.data() as Map<String, dynamic>;
                            String chatID = chat.id;
                            String chatDescription = data['description'];
                            chatTiles.add(TextButton(onPressed: () {} ,iconAlignment: IconAlignment.end ,child: Text('$chatID. $chatDescription', softWrap: false, textAlign: TextAlign.left,)));
                          }
                          return ListView(
                            children: chatTiles,
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              //Main Chat Tab
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder(
                    stream: streamProvider.messageStream,
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
                            onPressed: () {
                              messageTextController.clear();
                              try {
                                backEndService.sendMessage(chatRoomID: 'Chat1', userMessage: userMessage);
                              } catch (e) {
                                print(e);
                              }
                              ;
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
        crossAxisAlignment: sender == 'assistant' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
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
