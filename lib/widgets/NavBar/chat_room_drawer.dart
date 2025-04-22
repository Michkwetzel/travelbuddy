import 'package:flutter/material.dart';
import 'package:front_travelbuddy/change_notifiers/chat_state_provider.dart';
import 'package:front_travelbuddy/change_notifiers/fire_base_stream_provider.dart';
import 'package:front_travelbuddy/screens/welcome_screen.dart';
import 'package:front_travelbuddy/services/auth_service.dart';
import 'package:front_travelbuddy/services/back_end_service.dart';
import 'package:front_travelbuddy/widgets/NavBar/drawer_function_button.dart';
import 'package:front_travelbuddy/widgets/chat_screen/chat_room_stream_builder.dart';
import 'package:provider/provider.dart';

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
