import 'package:front_travelbuddy/change_notifiers/chat_state_provider.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  // Service Class for accessing FireStore from front-end
  UserModel userModel;
  final db = FirebaseFirestore.instance;
  ChatStateProvider chatStateProvider;

  FireStoreService({required this.userModel, required this.chatStateProvider});

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessageStream({required String chatRoomID}) {
    try {
      String userID = userModel.currentUser;
      if (chatRoomID == '' || userID == '' || userID == 'none' || chatRoomID == 'none') {
        return Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
      }

      String docPath = 'users/$userID/chats/$chatRoomID/messages';
      print('Attempting to get message stream for $docPath');
      var stream = db.collection(docPath).orderBy('timestamp', descending: true).snapshots();

      return stream;
    } catch (e) {
      print('Error getting message stream: $e');
      // Return an empty stream in case of error
      return Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatroomStream() {
    try {
      String userID = userModel.currentUser;
      if (userID == '' || userID == 'none') {
        return Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
      }
      print('Attempting to get chatroom stream for $userID');
      var stream = db.collection('users/$userID/chats').orderBy('timestamp_last_message', descending: true).snapshots();

      return stream;
    } catch (e) {
      print('Error getting chatroom stream: $e');
      return Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
    }
  }

  Future<bool> doesUserProfileExist(String userID) async {
    try {
      final docSnapshot = await db.collection('users').doc(userID).get();
      return docSnapshot.exists;
    } catch (e) {
      print('Error checking document existence: $e');
      return false;
    }
  }

  Future<void> getLatestChatroom() async {
    try {
      String userID = userModel.currentUser;
      String path = 'users/$userID/chats';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(path).orderBy('timestamp_last_message', descending: true).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        print(querySnapshot.docs.first.id);
        chatStateProvider.setCurrentChatroom(querySnapshot.docs.first.id);
      }
    } catch (e) {
      print('Error getting latest chat: $e');
    }
  }
}
