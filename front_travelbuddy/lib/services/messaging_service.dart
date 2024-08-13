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
    print('Send message called');
    String timesStamp = DateTime.now().toString();
    //String userID = userModel.currentUser;
    String userID = '6A1fdmwR5mKjrCEcQ7ZB';
    String chatRoomID = 'Chat1';

    Map<String, dynamic> request = {'userID': userID, 'chatID': chatRoomID, 'message': userMessage, 'timestamp': timesStamp};
    var response = await http.postRequest(path: '/receive_user_massage', request: request);

    return response;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessageStream({required String chatRoomID}) {
    print("Get stream called");
    //String userID = userModel.currentUser;
    String userID = '6A1fdmwR5mKjrCEcQ7ZB';
    String chatRoomID = 'Chat1';

    String docPath = 'users/$userID/chats/$chatRoomID/messages';

    var stream = db.collection(docPath).snapshots();
    return stream;
  }
}
