import 'package:travel_ai_front/change_notifiers/user_model.dart';
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
    String timesStamp = DateTime.now().toString();

    Map<String, dynamic> request = {'userID': userModel.currentUser, 'chatID': chatRoomID, 'message': userMessage, 'timestamp': timesStamp};
    var response = await http.postRequest(path: '/receive_user_massage', request: request);

    return response;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessageStream({required String chatRoomID}) {

    String userID = userModel.currentUser;
    userID = 'a9W8Vnx329PAam1J8o96fYQYsR32';
    String docPath = 'users/$userID/chats/$chatRoomID/messages';
    print(docPath);
    var stream = db.collection(docPath).snapshots();
    return stream;
  }
}
