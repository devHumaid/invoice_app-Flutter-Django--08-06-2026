import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class ApiClient {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  static Map<String, String> _headers({bool auth = false, String? token}) {
    final headers = {'Content-Type': 'application/json'};
    if (auth && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<http.Response> get(String endpoint) async {
    final token = await _getToken();
    return http.get(
      Uri.parse('${AppConstants.baseUrl}$endpoint'),
      headers: _headers(auth: true, token: token),
    );
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body,
      {bool auth = false}) async {
    String? token;
    if (auth) token = await _getToken();
    return http.post(
      Uri.parse('${AppConstants.baseUrl}$endpoint'),
      headers: _headers(auth: auth, token: token),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(String endpoint) async {
    final token = await _getToken();
    return http.delete(
      Uri.parse('${AppConstants.baseUrl}$endpoint'),
      headers: _headers(auth: true, token: token),
    );
  }
}
