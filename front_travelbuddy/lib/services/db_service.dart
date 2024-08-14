import 'package:front_travelbuddy/services/http_service.dart';

class DbService {
  final http = HttpService();

  /// send DB write request to backend. Must include collection and data.
  /// if docID empty then google will assign doc random docID
  /// returns docID
  Future<String> writeToDB({required String collection, required Map<String, dynamic> data, String? docId}) async {
    final String path = '/write_to_db';
    print('DocID $docId');

    final Map<String, dynamic> requestData = {
      'collection': collection,
      'data': data,
      if (docId != null) 'doc_id': docId, // Include docId only if it's not null
    };

    try {
      final response = await http.postRequest(path: path, request: requestData);
      return response;
    } catch (e) {
      print("Error: $e");
      return "Error occurred: $e";
    }
  }
}
