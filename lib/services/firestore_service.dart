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
      print('Log: getMessageStream called: userID: $userID chatRoomID: $chatRoomID');
      if (chatRoomID == '' || userID == '' || userID == 'none' || chatRoomID == 'none') {
        return Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
      }

      String docPath = 'users/$userID/chats/$chatRoomID/messages';
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
      print('Log: getChatroomStream called: userID: $userID');
      if (userID == '' || userID == 'none') {
        return Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
      }
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

  Future<void> getAndSetChatroomAtIndex({int chatroomIndex = 0, bool justDeletedChat = false}) async {
    //Set chatroom stream. If just deleted, it checks if current chat is one being deleted, if yes change to most recent however if current chat is latest, change to 2nd latest. This is because 1st will be deleted.
    try {
      String userID = userModel.currentUser;
      String path = 'users/$userID/chats';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(path).orderBy('timestamp_last_message', descending: true).limit(3).get();
      print('Log: getLatestChatroom called: userID: $userID');
      if (querySnapshot.docs.isNotEmpty) {
        List firstFewDocNames = [];
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          if (data['description'] != null) {
            firstFewDocNames.add(data['description']);
          }
        }
        if (justDeletedChat) {
          if (chatStateProvider.currentChat == querySnapshot.docs.first.id) {
            chatStateProvider.setCurrentChatroomName(firstFewDocNames[1] ?? '');
            chatStateProvider.setCurrentChatroom(querySnapshot.docs.elementAt(1).id);
          } else {
            chatStateProvider.setCurrentChatroomName(firstFewDocNames[0] ?? '');

            chatStateProvider.setCurrentChatroom(querySnapshot.docs.elementAt(0).id);
          }
        } else {
          chatStateProvider.setCurrentChatroomName(firstFewDocNames[0] ?? '');

          chatStateProvider.setCurrentChatroom(querySnapshot.docs.elementAt(chatroomIndex).id);
        }
      } else {
        chatStateProvider.setCurrentChatroomName('');
        chatStateProvider.setCurrentChatroom('none');
      }
    } catch (e) {
      chatStateProvider.setCurrentChatroom('none');
      print('Error getting latest chat: $e');
    }
  }
}
