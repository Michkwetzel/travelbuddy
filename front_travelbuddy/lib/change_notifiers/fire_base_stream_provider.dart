import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:front_travelbuddy/change_notifiers/chat_state_provider.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'package:front_travelbuddy/services/firestore_service.dart';

class FireStoreStreamProvider with ChangeNotifier {
  Stream<QuerySnapshot>? _messageStream;
  Stream<QuerySnapshot>? _chatRoomStream;

  ChatStateProvider chatStateProvider;
  UserModel userModel;
  FireStoreService fireStoreService;

  FireStoreStreamProvider({required this.userModel, required this.fireStoreService, required this.chatStateProvider}) {
    chatStateProvider.addListener(updateMessageStream);
  }

  Stream<QuerySnapshot>? get messageStream {
    if (_messageStream == null) {
      _messageStream = Stream.empty();
      return _messageStream;
    } else {
      return _messageStream;
    }
  }

  Stream<QuerySnapshot>? get chatRoomStream {
    if (_chatRoomStream == null) {
      _chatRoomStream = Stream.empty();
      return _chatRoomStream;
    } else {
      return _chatRoomStream;
    }
  }

  void updateMessageStream() {
    _messageStream = fireStoreService.getMessageStream(chatRoomID: chatStateProvider.currentChat);
    notifyListeners();
  }

  void updateChatRoomStream() {
    _chatRoomStream = fireStoreService.getChatroomStream();
    notifyListeners();
  }

  void userChangeStreamUpdate() {
    updateChatRoomStream();
    fireStoreService.getAndSetChatroomAtIndex(chatroomIndex: 0);
    notifyListeners();
  }
}
