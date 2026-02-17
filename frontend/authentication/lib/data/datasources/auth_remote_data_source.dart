import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';

class AuthRemoteDataSource {
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final payload = response.body.isNotEmpty ? jsonDecode(response.body) : {};
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(payload['message'] ?? 'Request failed');
    }
    return Map<String, dynamic>.from(payload);
  }
}
