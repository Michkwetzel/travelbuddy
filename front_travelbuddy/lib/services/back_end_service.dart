import 'dart:convert';

import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'package:front_travelbuddy/services/http_service.dart';

class BackEndService {
  //Works with http service. For database operations
  final HttpService http;
  final Spinner spinner;
  UserModel userModel;

  BackEndService({required this.userModel, required this.http, required this.spinner});

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
      return response.body;
    } catch (e) {
      print("Error: $e");
      return "Error occurred: $e";
    }
  }

  Future<String> createNewChatroom() async {
    try {
      spinner.showSpinner();
      const String path = 'create_new_chatroom';
      final Map<String, dynamic> request = {'userID': userModel.currentUser};

      final response = await http.postRequest(path: path, request: request);
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      String chatroomID = jsonResponse['chat_id'];
      print(chatroomID);
      spinner.hideSpinner();
      return chatroomID;
    } on Exception catch (e) {
      spinner.hideSpinner();
      print('error creating new chatroom: $e');
      return '';
    }
  }

  Future<String> addNewUser({required userCred}) async {
    //Send request to back end to add a new user profile to DB
    try {
      const String path = 'create_new_user_profile';

      final Map<String, dynamic> profileData = {
        'userID': userCred.user?.uid,
        'userEmail': userCred.user?.email,
        'displayName': userCred.user?.displayName,
      };

      final response = await http.postRequest(path: path, request: profileData);
      return response.body;
    } on Exception catch (e) {
      print('Error adding new user: $e');
      return 'Error: $e';
    }
  }

  Future<String> sendMessage({required String chatRoomID, required String userMessage}) async {
    try {
      String userID = userModel.currentUser;
      print('Send message called for user $userID');

      Map<String, dynamic> request = {'userID': userID, 'chatID': chatRoomID, 'message': userMessage};

      var response = await http.postRequest(path: '/receive_user_massage', request: request);
      var log = response.body;
      print('Message sent and response received: $log');
      return response.body;
    } catch (e) {
      print('Error sending message: $e');
      return 'Error: $e';
    }
  }
}
