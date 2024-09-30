import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front_travelbuddy/change_notifiers/chat_state_provider.dart';
import 'package:front_travelbuddy/change_notifiers/fire_base_stream_provider.dart';
import 'package:front_travelbuddy/screens/welcome_screen.dart';
import 'package:front_travelbuddy/services/auth_service.dart';
import 'package:front_travelbuddy/services/back_end_service.dart';
import 'package:front_travelbuddy/services/firestore_service.dart';
import 'package:front_travelbuddy/widgets/widgets.dart';
import 'package:front_travelbuddy/widgets/widgets_chat_screen.dart';
import 'package:provider/provider.dart';
import 'dart:core';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> with SingleTickerProviderStateMixin {
  bool isDrawerOpen = false;
  final messageTextController = TextEditingController();
  late AnimationController drawerController;

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        drawerController.forward();
      } else {
        drawerController.reverse();
      }
    });
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
    messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/background/chatscreen_jungle.jpg',
            fit: BoxFit.cover,
            width: size.width,
            height: size.height,
          ),
          // App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBarChatScreen(toggleDrawer: toggleDrawer),
          ),
          // Centered Message Display
          Positioned.fill(
            top: kToolbarHeight,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 700,
                child: MessageDisplayWidget(messageTextController: messageTextController),
              ),
            ),
          ),
          // Drawer
          AnimatedBuilder(
            animation: drawerController,
            builder: (context, child) {
              var drawerColor = Colors.black.withOpacity(0);
              if (size.width < 1024) {
                drawerColor = Colors.black.withOpacity(0.4);
              }

              return Container(
                color: drawerColor,
                child: Stack(
                  children: [
                    ChatRoomDrawer(
                      isDrawerOpen: isDrawerOpen,
                      controller: drawerController,
                      size: size,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.3, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                          child: IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () => toggleDrawer(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

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
                padding: const EdgeInsets.only(left: 35.75),
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
              SizedBox(height: 10)
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
  bool _isHovered = false;

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
