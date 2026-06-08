import 'dart:convert';
import '../models/item_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/app_constants.dart';

class ItemRepository {
  Future<List<ItemModel>> getItems() async {
    final response = await ApiClient.get(AppConstants.itemsEndpoint);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ItemModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load items');
  }

  Future<Map<String, dynamic>> createItem(Map<String, dynamic> data) async {
    final response = await ApiClient.post(AppConstants.itemsEndpoint, data, auth: true);
    return {'statusCode': response.statusCode, 'body': jsonDecode(response.body)};
  }

  Future<bool> deleteItem(int id) async {
    final response = await ApiClient.delete('/items/$id/delete/');
    return response.statusCode == 200;
  }
}
