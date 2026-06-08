import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/app_constants.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await ApiClient.post(
      AppConstants.loginEndpoint,
      {'username': username, 'password': password},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await ApiClient.post(AppConstants.registerEndpoint, data);
    return {'statusCode': response.statusCode, 'body': jsonDecode(response.body)};
  }

  Future<void> saveSession(String token, String refresh, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
    await prefs.setString(AppConstants.refreshTokenKey, refresh);
    await prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));
  }

  Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(AppConstants.userKey);
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
