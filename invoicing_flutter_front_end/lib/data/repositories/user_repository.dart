import 'dart:convert';
import '../models/user_model.dart';
import '../../core/network/api_client.dart';

class UserRepository {
  Future<List<UserModel>> getUsers() async {
    final response = await ApiClient.get('/users/');
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load users');
  }

  Future<bool> approveUser(int id) async {
    final response = await ApiClient.post('/users/$id/approve/', {}, auth: true);
    return response.statusCode == 200;
  }

  Future<bool> deleteUser(int id) async {
    final response = await ApiClient.delete('/users/$id/delete/');
    return response.statusCode == 200;
  }
}
