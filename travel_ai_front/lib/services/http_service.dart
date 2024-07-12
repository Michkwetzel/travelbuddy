import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpService {
  final backEndUri = 'http://127.0.0.1:5000';

  Future<String> postRequest(String path, Map<String, dynamic> data, Map<String,dynamic> headers  {'Content-Type': 'application/json'}) async {
    final finalUri = Uri.parse('$backEndUri/$path');

    try {
      final response = await http.post(
        finalUri,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Handle different status codes as needed
        print('Error: ${response.statusCode}, ${response.reasonPhrase}');
        return 'Error: ${response.statusCode}';
      }
    } on http.ClientException catch (e) {
      // Network-related error
      print('Network error: $e');
      return 'Network error: $e';
    } catch (e) {
      print(e);
      return 'An unexpected error occurred: $e';
    }
  }
}
