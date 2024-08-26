import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  // Service Class for accessing FireStore from front-end
  UserModel userModel;
  final db = FirebaseFirestore.instance;

  FireStoreService({required this.userModel});

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessageStream({required String chatRoomID}) {
    try {
      String userID = userModel.currentUser;
      print("Get stream called for user $userID");
      //String userID = '6A1fdmwR5mKjrCEcQ7ZB';
      String chatRoomID = '1';
      String docPath = 'users/$userID/chats/$chatRoomID/messages';

      var stream = db.collection(docPath).snapshots();
      print("Stream retrieved: $stream");
      return stream;
    } catch (e) {
      print('Error getting message stream: $e');
      // Return an empty stream in case of error
      return Stream.empty();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatroomStream() {
    try {
      String userID = userModel.currentUser;
      var stream = db.collection('users/$userID/chats').snapshots();
      return stream;
    } catch (e) {
      print('Error getting chatroom stream: $e');
      return Stream.empty();
    }
  }

  Future<bool> doesUserProfileExist(String userUID) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(userUID).get();
      return docSnapshot.exists;
    } catch (e) {
      print('Error checking document existence: $e');
      return false;
    }
  }
}
