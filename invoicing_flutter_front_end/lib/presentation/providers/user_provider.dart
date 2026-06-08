import 'package:flutter/foundation.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repo = UserRepository();

  List<UserModel> _users = [];
  bool _loading = false;
  String? _error;

  List<UserModel> get users => _users;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchUsers() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _users = await _repo.getUsers();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> approveUser(int id) async {
    final success = await _repo.approveUser(id);
    if (success) await fetchUsers();
    return success;
  }

  Future<bool> deleteUser(int id) async {
    final success = await _repo.deleteUser(id);
    if (success) await fetchUsers();
    return success;
  }
}
