import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../screens/common/logger.dart';
import '../services/services.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  String? _token;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;


  final Services _service = Services();

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  AuthProvider() {
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    _token = await _storage.read(key: 'auth_token');
    if (_token != null) {
      final valid = await _validateToken(_token!);
      if (valid) {
        _isLoggedIn = true;
      } else {
        await logout();
      }
    }
    notifyListeners();
  }

  Future<bool> _validateToken(String token) async {
    final response = await http.get(
      Uri.parse('https://your-api.com/validate-token'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String apiKey = await _service.api.login(username, password);

      // Assign token and update login status
      _token = apiKey;
      _isLoggedIn = true;

      await _storage.write(key: 'auth_token', value: _token);
    } catch (e) {
      logger.w(
        'login(catch): ${e.toString()}',
      );
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _isLoggedIn = false;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }

  String? get token => _token;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void forceLogout() => logout();
}
