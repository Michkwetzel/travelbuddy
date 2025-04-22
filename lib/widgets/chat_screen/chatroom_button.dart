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
import 'package:front_travelbuddy/widgets/chat_screen/bottom_text_field_and_send_button.dart';
import 'package:front_travelbuddy/widgets/global/dialog_pop_ups.dart';
import 'package:provider/provider.dart';

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
