import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  String? _token;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

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

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://your-api.com/login'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      _isLoggedIn = true;
      await _storage.write(key: 'auth_token', value: _token);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _token = null;
    _isLoggedIn = false;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }

  String? get token => _token;

  void forceLogout() => logout();
}
