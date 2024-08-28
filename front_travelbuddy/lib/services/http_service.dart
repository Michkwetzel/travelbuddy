import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class HttpService {
  final String baseUrl;

  HttpService({this.baseUrl = 'http://127.0.0.1:5000/'});

  /// Sends post request to flask server. returns response.body
  /// Throws errors if responce code != 200 and any other errors
  Future<Response> postRequest({required String path, required Map<String, dynamic> request, Map<String, String> headers = const {'Content-Type': 'application/json'}}) async {
    final uri = Uri.parse('$baseUrl$path');

    try {
      print("Attempt to make post request. URL: $uri, request: $request, headers: $headers ");
      final response = await http.post(uri, body: jsonEncode(request), headers: headers);
      print('post requst done. Response $response');

      if (response.statusCode == 200) {
        return response;
      } else {
        throw HttpException('Request failed with status: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: $e');
    } catch (e) {
      throw UnexpectedException('An unexpected error occurred: $e');
    }
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class UnexpectedException implements Exception {
  final String message;
  UnexpectedException(this.message);
}
