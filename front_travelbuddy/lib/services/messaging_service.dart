import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'http_service.dart';

class MessagingService {
  final http = HttpService();
  final UserModel userModel;
  final db = FirebaseFirestore.instance;

  // Provider usermodel is passed to messagingService
  MessagingService({required this.userModel});

  // Error catching to make sure its ocrrect userID
  Future<String> sendMessage({required String chatRoomID, required String userMessage}) async {
  try {
    String timestamp = DateTime.now().toString();
    String userID = userModel.currentUser;
    print('Send message called for user $userID');
    //String userID = '6A1fdmwR5mKjrCEcQ7ZB';
    String chatRoomID = '1';
    
    Map<String, dynamic> request = {
      'userID': userID,
      'chatID': chatRoomID,
      'message': userMessage,
      'timestamp': timestamp
    };
    
    var response = await http.postRequest(path: '/receive_user_massage', request: request);
    print('Message sent and response received: $response');
    return response;
  } catch (e) {
    print('Error sending message: $e');
    return 'Error: $e';
  }
}

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
}
