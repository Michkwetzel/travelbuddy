import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'package:front_travelbuddy/services/firestore_service.dart';

class FireStoreStreamProvider with ChangeNotifier {
  Stream<QuerySnapshot>? _messageStream;
  Stream<QuerySnapshot>? get messageStream => _messageStream;

  Stream<QuerySnapshot>? _chatRoomStream;
  Stream<QuerySnapshot>? get chatRoomStream => _chatRoomStream;

  UserModel userModel;
  FireStoreService fireStoreService;

  FireStoreStreamProvider({required this.userModel, required this.fireStoreService});

  void initializeMessageStream(String chatRoomID) {
    print('Message stream initialized');
    _messageStream = fireStoreService.getMessageStream(chatRoomID: chatRoomID);
  }

  void initializeChatRoomStream() {
    _chatRoomStream = fireStoreService.getChatroomStream();
  }

  void updateStreams(){
    String currentUser = userModel.currentUser;
    print('update stream for user: $currentUser');
    initializeChatRoomStream();
    initializeMessageStream('1');
  }
}
