import 'package:flutter/material.dart';
import 'package:front_travelbuddy/change_notifiers/chat_state_provider.dart';
import 'package:front_travelbuddy/services/back_end_service.dart';
import 'package:provider/provider.dart';

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
