import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front_travelbuddy/change_notifiers/chat_state_provider.dart';
import 'package:front_travelbuddy/change_notifiers/fire_base_stream_provider.dart';
import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/services/back_end_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'dart:core';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> with SingleTickerProviderStateMixin {
  bool isDrawerOpen = false;
  String userMessage = '';
  final messageTextController = TextEditingController();
  late BackEndService backEndService;
  late FireStoreStreamProvider streamProvider;
  late ChatStateProvider chatStateProvider;
  late AnimationController drawerController;

  void toggleDrawer() {
    if (drawerController.isCompleted) {
      drawerController.reverse();
    } else {
      drawerController.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    drawerController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    drawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    backEndService = Provider.of<BackEndService>(context, listen: false);
    streamProvider = Provider.of<FireStoreStreamProvider>(context);
    chatStateProvider = Provider.of<ChatStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text("Travel Buddy"),
          leading: IconButton(
            icon: AnimatedIcon(icon: AnimatedIcons.menu_close, progress: drawerController),
            onPressed: toggleDrawer,
          )),
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<Spinner>(context).spinner,
        child: Row(
          children: [
            ChatRoomDrawer(isDrawerOpen: isDrawerOpen, controller: drawerController, backEndService: backEndService, chatStateProvider: chatStateProvider, streamProvider: streamProvider),
            Expanded(
              child: Column(
                //Main Chat Tab
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        streamProvider.updateChatRoomStream();
                      },
                      child: Text('Get latest chat')),
                  StreamBuilder(
                      stream: streamProvider.messageStream,
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        try {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return const Text("Loading");
                          }

                          final messages = snapshot.data!.docs;
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
                        } on Exception {
                          return const Text("Loading");
                        }
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
                                  backEndService.sendMessage(chatRoomID: chatStateProvider.currentChat, userMessage: userMessage);
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
      ),
    );
  }
}

class ChatRoomDrawer extends StatelessWidget {
  const ChatRoomDrawer({
    super.key,
    required this.isDrawerOpen,
    required this.backEndService,
    required this.chatStateProvider,
    required this.streamProvider,
    required this.controller,
  });

  final bool isDrawerOpen;
  final BackEndService backEndService;
  final ChatStateProvider chatStateProvider;
  final FireStoreStreamProvider streamProvider;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: 200 * controller.value,
          color: Colors.blue[100],
          child: Column(
            children: [
              DrawerItemBuilder(
                  controller: controller,
                  icon: Icons.abc_rounded,
                  text: "Create New Chat",
                  onTap: () async {
                    String chatRoomID = await backEndService.createNewChatroom();
                    chatStateProvider.setCurrentChatroom(chatRoomID);
                    streamProvider.updateMessageStream();
                  }),
              ChatRoomStreamBuilder(streamProvider: streamProvider, chatStateProvider: chatStateProvider, controller: controller),
            ],
          ),
        );
      },
    );
  }
}

class ChatRoomStreamBuilder extends StatelessWidget {
  const ChatRoomStreamBuilder({
    super.key,
    required this.streamProvider,
    required this.chatStateProvider,
    required this.controller,
  });

  final FireStoreStreamProvider streamProvider;
  final ChatStateProvider chatStateProvider;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: StreamBuilder(
          stream: streamProvider.chatRoomStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong', softWrap: false, maxLines: 1,);
            } else if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('Loading', softWrap: false, maxLines: 1,);
            } else {
              List<DrawerItemBuilder> chatTiles = [];
              final chats = snapshot.data!.docs;
              for (var chat in chats) {
                // Maybe here is overkill in code
                Map<String, dynamic> data = chat.data() as Map<String, dynamic>;
                String chatDescription = data['description'];
                chatTiles.add(DrawerItemBuilder(
                  controller: controller,
                  icon: Icons.ac_unit,
                  text: chatDescription,
                  onTap: () {
                    String chatRoomID = chat.id;
                    chatStateProvider.setCurrentChatroom(chatRoomID);
                  },
                ));
              }
              return ListView(children: chatTiles);
              
            }
          }),
    );
  }
}

class DrawerItemBuilder extends StatelessWidget {
  const DrawerItemBuilder({
    super.key,
    required this.controller,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final AnimationController controller;
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Align(
              alignment: Alignment(-1.0 + controller.value, 0.0),
              child: TextButton.icon(
                icon: Icon(icon),
                label: Text(
                  text,
                  softWrap: false,
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                ),
                onPressed: onTap,
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            );
          },
        ),
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
