import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front_travelbuddy/change_notifiers/chat_state_provider.dart';
import 'package:front_travelbuddy/change_notifiers/fire_base_stream_provider.dart';
import 'package:front_travelbuddy/widgets/widgets_chat_screen.dart';
import 'package:provider/provider.dart';

class ChatRoomStreamBuilder extends StatelessWidget {
  const ChatRoomStreamBuilder({
    super.key,
    required this.controller,
  });

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    FireStoreStreamProvider streamProvider = Provider.of<FireStoreStreamProvider>(context);
    ChatStateProvider chatStateProvider = Provider.of<ChatStateProvider>(context);

    return Flexible(
      child: StreamBuilder(
          stream: streamProvider.chatRoomStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text(
                'Something went wrong',
                softWrap: false,
                maxLines: 1,
              );
            } else if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Expanded(child: SizedBox());
            } else {
              List<ChatRoomButton> chatTiles = [];
              final chats = snapshot.data!.docs;
              for (var chat in chats) {
                // Maybe here is overkill in code
                Map<String, dynamic> data = chat.data() as Map<String, dynamic>;
                String chatDescription = data['description'] ?? "Travel Chat";

                String chatroomID = chat.id;
                chatTiles.add(ChatRoomButton(
                  controller: controller,
                  icon: Icons.chat_bubble_outline,
                  text: chatDescription,
                  chatroomID: chatroomID,
                  onTap: () {
                    print(chatroomID);
                    chatStateProvider.setCurrentChatroomName(chatDescription);
                    chatStateProvider.setCurrentChatroom(chatroomID);
                  },
                ));
              }
              return ListView(children: chatTiles);
            }
          }),
    );
  }
}
