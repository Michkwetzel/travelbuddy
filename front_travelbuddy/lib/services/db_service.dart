import 'package:front_travelbuddy/services/http_service.dart';

class DbService {
  final http = HttpService();

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
}
