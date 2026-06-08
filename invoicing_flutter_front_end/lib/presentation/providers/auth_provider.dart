import 'package:flutter/foundation.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';


enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAdmin => _user?.role == 'admin';

  Future<void> checkSession() async {
    _user = await _repo.getSavedUser();
    _status = _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repo.login(username, password);
      if (result.containsKey('access')) {
        final user = UserModel.fromJson(result['user']);
        await _repo.saveSession(result['access'], result['refresh'], user);
        _user = user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['error'] ?? 'Login failed';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection error. Is the server running?';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    _status = AuthStatus.loading;
    notifyListeners();
    try {
      final result = await _repo.register(data);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return result;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return {'statusCode': 500, 'body': 'Connection error'};
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
