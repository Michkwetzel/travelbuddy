import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front_travelbuddy/change_notifiers/chat_state_provider.dart';
import 'package:front_travelbuddy/change_notifiers/fire_base_stream_provider.dart';
import 'package:front_travelbuddy/services/back_end_service.dart';
import 'package:provider/provider.dart';

class AppBarChatScreen extends StatelessWidget implements PreferredSizeWidget {
  const AppBarChatScreen({
    required this.toggleDrawer,
    super.key,
  });

  final VoidCallback toggleDrawer;

  @override
  Widget build(BuildContext context) {
    ChatStateProvider chatStateProvider = Provider.of<ChatStateProvider>(context);
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0),
      title: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 150,
              child: Text(
                chatStateProvider.currentChatroomName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
          Spacer(),
          Text(
            "Travel Buddy",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: TextDecoration.none,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(width: 150),
          Spacer()
        ],
      ),
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.3, vertical: 8),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => toggleDrawer(),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BottomTextFieldAndSendButton extends StatelessWidget {
  const BottomTextFieldAndSendButton({
    super.key,
    required this.messageTextController,
  });

  final TextEditingController messageTextController;

  @override
  Widget build(BuildContext context) {
    ChatStateProvider chatStateProvider = Provider.of<ChatStateProvider>(context);
    BackEndService backEndService = Provider.of<BackEndService>(context);
    String userMessage = "";

    void onSubmit() {
      messageTextController.clear();
      try {
        backEndService.sendMessage(chatRoomID: chatStateProvider.currentChat, userMessage: userMessage);
      } catch (e) {
        print(e);
      }
    }

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 25, left: 25, top: 10),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: TextField(
                  controller: messageTextController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    userMessage = value;
                  },
                  onSubmitted: (value) => onSubmit(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                    CircleBorder(), // Make the button circular
                  ),
                ),
                onPressed: () => onSubmit(),
                icon: Icon(Icons.send, color: Colors.black)),
          ),
        ],
      ),
      SizedBox(
        height: 15,
      )
    ]);
  }
}

class MessageDisplayWidget extends StatelessWidget {
  const MessageDisplayWidget({
    super.key,
    required this.messageTextController,
  });

  final TextEditingController messageTextController;

  @override
  Widget build(BuildContext context) {
    FireStoreStreamProvider streamProvider = Provider.of<FireStoreStreamProvider>(context);

    return Column(
      //Main Chat Tab
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
        BottomTextFieldAndSendButton(messageTextController: messageTextController)
      ],
    );
  }
}

class MessageBuble extends StatelessWidget {
  MessageBuble({required this.message, required this.sender, super.key});

  String message;
  final String sender;

  @override
  Widget build(BuildContext context) {
    if (message.endsWith('\n')) {
      message = message.replaceFirst(RegExp(r'\n$'), '');
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: sender == 'assistant' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 650),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 7,
              color: Colors.white,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'Montserrat'),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
