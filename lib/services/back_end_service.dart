import 'dart:convert';

import 'package:front_travelbuddy/change_notifiers/chat_history_provider.dart';
import 'package:front_travelbuddy/change_notifiers/chat_state_provider.dart';
import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/change_notifiers/user_model.dart';
import 'package:front_travelbuddy/services/firestore_service.dart';
import 'package:front_travelbuddy/services/http_service.dart';

class BackEndService {
  //Works with http service. For database operations
  final HttpService http;
  final Spinner spinner;
  final FireStoreService fireStoreService;
  ChatStateProvider chatStateProvider;
  ChatHistoryProvider chatHistoryProvider;
  UserModel userModel;

  BackEndService({required this.userModel, required this.http, required this.spinner, required this.fireStoreService, required this.chatStateProvider, required this.chatHistoryProvider});

  /// send DB write request to backend. Must include collection and data.
  /// if docID empty then google will assign doc random docID
  /// returns docID
  Future<String> writeToDB({required String collection, required Map<String, dynamic> data, String? docId}) async {
    spinner.showSpinner();

    final String path = '/write_to_db';
    print('DocID $docId');

    final Map<String, dynamic> request_body = {
      'collection': collection,
      'data': data,
      if (docId != null) 'doc_id': docId, // Include docId only if it's not null
    };

    try {
      final response = await http.postRequest(path: path, request: request_body);
      spinner.hideSpinner();

      return response.body;
    } catch (e) {
      spinner.hideSpinner();

      print("Error: $e");
      return "Error occurred: $e";
    }
  }

  Future<String> deleteChatroom({required String chatroomID}) async {
    try {
      spinner.showSpinner();
      const String path = 'https://delete-chatroom-3zk5a74c4q-uc.a.run.app';
      final Map<String, dynamic> request = {'userID': userModel.currentUser, 'chatroomID': chatroomID};
      print('Delete chatroom request: $request');
      final response = await http.postRequest(path: path, request: request);
      print(response.body);
      spinner.hideSpinner();

      return response.body;
    } catch (e) {
      spinner.hideSpinner();
      print('error deleting chatroom - $chatroomID. Error: $e');
      spinner.hideSpinner();

      return '';
    }
  }

  Future<void> editChatroomDescription({required String chatroomID, required String newDescription}) async {
    try {
      spinner.showSpinner();

      const String path = 'https://edit-chatroom-description-3zk5a74c4q-uc.a.run.app';
      final Map<String, dynamic> request = {'userID': userModel.currentUser, 'chatroomID': chatroomID, 'newDescription': newDescription};

      final response = await http.postRequest(path: path, request: request);
      if (chatStateProvider.currentChat == chatroomID) {
        chatStateProvider.setCurrentChatroomName(newDescription);
      }
      print(response.body);
      spinner.hideSpinner();
    } on Exception catch (e) {
      spinner.hideSpinner();
      print('Error changing chatroom name ${e.toString()}');
    }
  }

  Future<String> createNewChatroom() async {
    try {
      spinner.showSpinner();
      const String path = 'https://create-new-chatroom-3zk5a74c4q-uc.a.run.app';
      final Map<String, dynamic> request = {'userID': userModel.currentUser};

      final response = await http.postRequest(path: path, request: request);
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      String chatroomID = jsonResponse['chatroom_id'];
      print(chatroomID);
      spinner.hideSpinner();
      return chatroomID;
    } on Exception catch (e) {
      spinner.hideSpinner();
      print('error creating new chatroom. Error: ${e.toString()}');
      return '';
    }
  }

  Future<String> addNewUser({required userCred}) async {
    //Send request to back end to add a new user profile to DB
    try {
      const String path = 'https://create-new-user-profile-3zk5a74c4q-uc.a.run.app';

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
      spinner.showSpinner();

      final String userID = userModel.currentUser;
      final List<String> chatHistory = chatHistoryProvider.chatHistory;

      print('Send message called for user $userID');

      final request = {'userID': userID, 'chatroomID': chatRoomID, 'message': userMessage, 'chatHistory': chatHistory};

      final response = await http.postRequest(path: 'https://receive-user-message-3zk5a74c4q-uc.a.run.app', request: request);

      spinner.hideSpinner();

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw ('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      spinner.hideSpinner();
      print('Error sending message: $e');
      return 'Error: $e';
    }
  }
}
