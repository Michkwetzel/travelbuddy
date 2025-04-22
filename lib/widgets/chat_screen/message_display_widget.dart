import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front_travelbuddy/change_notifiers/chat_history_provider.dart';
import 'package:front_travelbuddy/change_notifiers/fire_base_stream_provider.dart';
import 'package:front_travelbuddy/widgets/chat_screen/bottom_text_field_and_send_button.dart';
import 'package:front_travelbuddy/widgets/chat_screen/message_buble.dart';
import 'package:provider/provider.dart';

class MessageDisplayWidget extends StatelessWidget {
  const MessageDisplayWidget({
    super.key,
    required this.messageTextController,
  });

  final TextEditingController messageTextController;

  @override
  Widget build(BuildContext context) {
    FireStoreStreamProvider streamProvider = Provider.of<FireStoreStreamProvider>(context);
    ChatHistoryProvider chatHistoryProvider = Provider.of<ChatHistoryProvider>(context);

    return Column(
      //Main Chat Tab
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder(
            stream: streamProvider.messageStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              try {
                if (snapshot.hasError) {
                  return const Text(
                    'Something went wrong',
                    style: TextStyle(color: Colors.white),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text(
                    "Loading",
                    style: TextStyle(color: Colors.white),
                  );
                }

                List<String> messageHistory = [];

                final messages = snapshot.data!.docs;
                String role = '';
                List<MessageBuble> messageWidgets = [];

                for (var message in messages) {
                  Map<String, dynamic> data = message.data() as Map<String, dynamic>;
                  final text = data['message'];
                  role = data['role'];
                  final messageWidget = MessageBuble(message: text, sender: role);
                  messageHistory.add('role: $role, message: $text');
                  messageWidgets.add(messageWidget);
                }
                chatHistoryProvider.setHistory(messageHistory);

                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
