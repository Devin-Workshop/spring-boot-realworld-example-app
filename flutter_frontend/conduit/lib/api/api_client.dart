import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client httpClient;

  ApiClient({
    required this.baseUrl,
    http.Client? httpClient,
  }) : this.httpClient = httpClient ?? http.Client();

  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl$path'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(
    String path, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(
    String path, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final response = await httpClient.put(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    final response = await httpClient.delete(
      Uri.parse('$baseUrl$path'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw http.ClientException(
        'Error ${response.statusCode}: ${response.body}',
        Uri.parse(response.request?.url.toString() ?? ''),
      );
    }
  }
}
