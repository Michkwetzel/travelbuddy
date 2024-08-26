import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'package:front_travelbuddy/services/http_service.dart';

class BackEndService {

  //Works with http service. For database operations
  final HttpService http;
  UserModel userModel;

  BackEndService({required this.userModel, required this.http});

  /// send DB write request to backend. Must include collection and data.
  /// if docID empty then google will assign doc random docID
  /// returns docID
  Future<String> writeToDB({required String collection, required Map<String, dynamic> data, String? docId}) async {
    final String path = '/write_to_db';
    print('DocID $docId');

    final Map<String, dynamic> request_body = {
      'collection': collection,
      'data': data,
      if (docId != null) 'doc_id': docId, // Include docId only if it's not null
    };

    try {
      final response = await http.postRequest(path: path, request: request_body);
      return response;
    } catch (e) {
      print("Error: $e");
      return "Error occurred: $e";
    }
  }

  Future<String> addNewUser({required userCred}) async {
    //Send request to back end to add a new user profile to DB
    const String path = 'create_new_user_profile';

    final Map<String, dynamic> profileData = {
      'userUID': userCred.user?.uid,
      'userEmail': userCred.user?.email,
      'displayName': userCred.user?.displayName,
    };

    final response = await http.postRequest(path: path, request: profileData);
    return response;
  }

  Future<String> sendMessage({required String chatRoomID, required String userMessage}) async {
    try {
      String timestamp = DateTime.now().toString();
      String userID = userModel.currentUser;
      print('Send message called for user $userID');
      //String userID = '6A1fdmwR5mKjrCEcQ7ZB';
      String chatRoomID = '1';

      Map<String, dynamic> request = {'userID': userID, 'chatID': chatRoomID, 'message': userMessage, 'timestamp': timestamp};

      var response = await http.postRequest(path: '/receive_user_massage', request: request);
      print('Message sent and response received: $response');
      return response;
    } catch (e) {
      print('Error sending message: $e');
      return 'Error: $e';
    }
  }
}
