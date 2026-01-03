import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthService extends ChangeNotifier {
  String? _currentUser;
  SharedPreferences? _prefs;

  String? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> initializeAuth() async {
    _prefs = await SharedPreferences.getInstance();
    _currentUser = _prefs?.getString('current_user');
    notifyListeners();
  }

  Future<bool> login(String username) async {
    final trimmed = username.trim();
    if (trimmed.isEmpty) {
      return false;
    }

    _currentUser = trimmed;
    await _prefs?.setString('current_user', _currentUser!);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _currentUser = null;
    await _prefs?.remove('current_user');
    notifyListeners();
  }
}
