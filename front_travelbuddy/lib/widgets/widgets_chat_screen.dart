import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front_travelbuddy/change_notifiers/chat_history_provider.dart';
import 'package:front_travelbuddy/change_notifiers/chat_state_provider.dart';
import 'package:front_travelbuddy/change_notifiers/fire_base_stream_provider.dart';
import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/screens/welcome_screen.dart';
import 'package:front_travelbuddy/services/auth_service.dart';
import 'package:front_travelbuddy/services/back_end_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:front_travelbuddy/services/firestore_service.dart';
import 'package:front_travelbuddy/widgets/widgets.dart';
import 'package:provider/provider.dart';

// AppBar Widget
class AppBarChatScreen extends StatelessWidget implements PreferredSizeWidget {
  const AppBarChatScreen({
    required this.toggleDrawer,
    super.key,
  });

  final VoidCallback toggleDrawer;

  @override
  Widget build(BuildContext context) {
    bool mobile = false;
    if (MediaQuery.of(context).size.width < 600) {
      mobile = true;
    }

    ChatStateProvider chatStateProvider = Provider.of<ChatStateProvider>(context);
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0),
      title: Row(
        children: [
          if (!mobile)
            SizedBox(
              width: 150,
              child: Text(
                chatStateProvider.currentChatroomName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          Spacer(),
          Text(
            "Travel Buddy",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              decoration: TextDecoration.none,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(width: mobile ? 56 : 150 + 76),
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

// Message Display and User Text Input widgetes
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

    bool mobile = false;
    if (MediaQuery.of(context).size.width < 600) {
      mobile = true;
    }

    void onSubmit() {
      messageTextController.clear();
      try {
        backEndService.sendMessage(chatRoomID: chatStateProvider.currentChat, userMessage: userMessage);
      } catch (e) {
        print(e);
      }
    }

    return Padding(
      padding: mobile ? EdgeInsets.only(bottom: 15, top: 10, right: 10, left: 10) : const EdgeInsets.only(bottom: 15, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
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
          SizedBox(
            width: 15,
          ),
          IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                shape: WidgetStateProperty.all<OutlinedBorder>(
                  CircleBorder(), // Make the button circular
                ),
              ),
              onPressed: () => onSubmit(),
              icon: Icon(Icons.send, color: Colors.black)),
        ],
      ),
    );
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
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text("Loading");
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

// Side Drawer Widgets
class ChatRoomDrawer extends StatelessWidget {
  const ChatRoomDrawer({
    super.key,
    required this.isDrawerOpen,
    required this.controller,
    required this.size,
  });

  final bool isDrawerOpen;
  final AnimationController controller;
  final Size size;

  @override
  Widget build(BuildContext context) {
    BackEndService backEndService = Provider.of<BackEndService>(context);
    ChatStateProvider chatStateProvider = Provider.of<ChatStateProvider>(context);
    FireStoreStreamProvider streamProvider = Provider.of<FireStoreStreamProvider>(context);
    AuthService authService = Provider.of<AuthService>(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: 205 * controller.value,
          color: Colors.white.withOpacity(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 55,
              ),
              Padding(
                padding: EdgeInsets.only(left: 29.6, bottom: 5, top: 5),
                child: DrawerFunctionButton(
                    text: 'New Chat',
                    icon: Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.black87,
                    ),
                    controller: controller,
                    onTap: () async {
                      String chatRoomID = await backEndService.createNewChatroom();
                      chatStateProvider.setCurrentChatroomName('New chatroom');
                      chatStateProvider.setCurrentChatroom(chatRoomID);
                      streamProvider.updateMessageStream();
                    }),
              ),
              ChatRoomStreamBuilder(controller: controller),
              Padding(
                padding: const EdgeInsets.only(left: 35.75, bottom: 15, top: 150),
                child: DrawerFunctionButton(
                    controller: controller,
                    onTap: () => authService.signOut(
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen())),
                        ),
                    icon: Icon(
                      Icons.logout,
                      size: 20,
                    ),
                    text: 'Log Out'),
              ),
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

class DrawerFunctionButton extends StatelessWidget {
  final VoidCallback onTap;
  final AnimationController controller;
  final Icon icon;
  final String text;

  const DrawerFunctionButton({super.key, required this.controller, required this.onTap, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 35),
      child: ClipRect(
        child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return TextButton.icon(
                icon: icon,
                label: Text(
                  text,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black, decoration: TextDecoration.none, fontFamily: 'Roboto'),
                ),
                onPressed: onTap,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  alignment: Alignment.centerLeft,
                ),
              );
            }),
      ),
    );
  }
}

class ChatRoomButton extends StatefulWidget {
  const ChatRoomButton({
    super.key,
    required this.controller,
    required this.text,
    required this.icon,
    required this.onTap,
    required this.chatroomID,
  });

  final AnimationController controller;
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final String chatroomID;

  @override
  State<ChatRoomButton> createState() => _ChatRoomButtonState();
}

class _ChatRoomButtonState extends State<ChatRoomButton> {
  @override
  Widget build(BuildContext context) {
    BackEndService backEndService = Provider.of<BackEndService>(context);
    ChatStateProvider chatStateProvider = Provider.of<ChatStateProvider>(context);
    FireStoreService fireStoreService = Provider.of<FireStoreService>(context);

    return Container(
      constraints: BoxConstraints(minHeight: 50),
      child: ClipRect(
        child: AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            BuildContext dialogContext = context;
            return Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: TextButton.icon(
                    icon: Icon(widget.icon, color: Colors.black),
                    label: Text(
                      widget.text,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: Colors.black, fontFamily: 'Roboto', fontWeight: FontWeight.w400, fontSize: 13),
                    ),
                    onPressed: widget.onTap,
                    style: TextButton.styleFrom(
                      fixedSize: Size(double.infinity, 37),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(right: 16, left: 10),
                      backgroundColor: Colors.white,
                      overlayColor: Colors.white,
                    ),
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  color: Colors.white,
                  Icons.more_vert,
                  size: 20,
                ),
                offset: Offset(15, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                elevation: 8,
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    child: Text('Delete Chat'),
                    value: 'delete',
                    onTap: () {
                      if (widget.chatroomID == chatStateProvider.currentChat) {
                        fireStoreService.getAndSetChatroomAtIndex(justDeletedChat: true);
                      }
                      backEndService.deleteChatroom(chatroomID: widget.chatroomID);
                    },
                  ),
                  PopupMenuItem<String>(
                    child: Text('Rename Chat'),
                    value: 'rename',
                    onTap: () {
                      editChatDescriptionDialogue(
                        dialogContext,
                        widget.text,
                        (newDescription) => backEndService.editChatroomDescription(
                          chatroomID: widget.chatroomID,
                          newDescription: newDescription,
                        ),
                      );
                    },
                  ),
                ],
              )
            ]);
          },
        ),
      ),
    );
  }
}
