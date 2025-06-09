import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solar_cargo/models/jwt_keys.dart';

import '../screens/common/logger.dart';
import '../services/services.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Services _service = Services();

  String? _bearerToken;
  String? _refreshToken;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    await _checkLogin();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _checkLogin() async {
    _bearerToken = await _readToken('bearer_token');
    if (_bearerToken != null) {
      final isValid = await _validateToken();
      if (isValid) {
        _setLoggedIn(true);
      } else {
        await logout();
      }
    } else {
      _setLoggedIn(false);
    }
  }

  Future<bool> _validateToken() async {
    try {
      final refreshToken = await _readToken('refresh_token');
      if (refreshToken == null) return false;

      final String bearerToken = await _service.api.updateToken(refreshToken);

      // Persist new bearer token
      await _writeToken('bearer_token', bearerToken);

      return true;
    } catch (e) {
      logger.w('validateToken error: $e');
      return false;
    }
  }

  Future<void> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final JwtKeys jwtKeys = await _service.api.login(username, password);
      await _persistTokens(jwtKeys);
      _setLoggedIn(true);
    } catch (e) {
      logger.w('login error: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _clearTokens();
    _setLoggedIn(false);
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  void forceLogout() => logout();

  // --- Private methods ---

  Future<void> _persistTokens(JwtKeys jwtKeys) async {
    _bearerToken = jwtKeys.bearerToken;
    _refreshToken = jwtKeys.refreshToken;

    await _writeToken('bearer_token', _bearerToken);
    await _writeToken('refresh_token', _refreshToken);
  }

  Future<void> _clearTokens() async {
    _bearerToken = null;
    _refreshToken = null;

    await _deleteToken('bearer_token');
    await _deleteToken('refresh_token');
  }

  void _setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // --- Token persistence helpers ---

  Future<void> _writeToken(String key, String? value) async {
    if (value != null) {
      await _storage.write(key: key, value: value);
    }
  }

  Future<String?> _readToken(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> _deleteToken(String key) async {
    await _storage.delete(key: key);
  }
}
