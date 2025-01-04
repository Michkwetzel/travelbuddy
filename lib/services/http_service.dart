import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpService {
  HttpService();
  Future<http.Response> postRequest({required String path, required Map<String, dynamic> request, Map<String, String>? headers}) async {
    final Uri uri = Uri.parse(path);
    //final token = await GoogleAuth.getToken(); 

    try {
      print("POST Request: URL=${uri.toString()}, Body=${jsonEncode(request)}");

      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(request));

      return response;
    } catch (e) {
      print('Error in postRequest: ${e.toString()}');
      // Rethrow the error to be handled by the caller
      rethrow;
    }
  }
}
