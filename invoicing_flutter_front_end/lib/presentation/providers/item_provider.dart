import 'package:flutter/foundation.dart';
import '../../data/models/item_model.dart';
import '../../data/repositories/item_repository.dart';

class ItemProvider extends ChangeNotifier {
  final ItemRepository _repo = ItemRepository();

  List<ItemModel> _items = [];
  bool _loading = false;
  String? _error;

  List<ItemModel> get items => _items;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchItems() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await _repo.getItems();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> addItem(Map<String, dynamic> data) async {
    final result = await _repo.createItem(data);
    if (result['statusCode'] == 201) await fetchItems();
    return result;
  }

  Future<bool> deleteItem(int id) async {
    final success = await _repo.deleteItem(id);
    if (success) await fetchItems();
    return success;
  }
}
