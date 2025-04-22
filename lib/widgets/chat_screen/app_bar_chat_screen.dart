import 'package:flutter/material.dart';
import 'package:front_travelbuddy/change_notifiers/chat_state_provider.dart';
import 'package:provider/provider.dart';

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
