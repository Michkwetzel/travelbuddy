import 'package:flutter/material.dart';
import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/widgets/widgets_chat_screen.dart';
import 'dart:core';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

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
      body: ModalProgressHUD(
        offset: Offset(size.width / 2, size.height * 0.8),
        progressIndicator: CircularProgressIndicator(
          color: Colors.blue,
        ),
        inAsyncCall: Provider.of<Spinner>(context).spinner,
        opacity: 0,
        blur: 0,
        child: Stack(
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
      ),
    );
  }
}
