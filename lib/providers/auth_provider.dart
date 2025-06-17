import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/token_storage.dart';
import '../models/user.dart';
import '../screens/common/logger.dart';
import '../services/services.dart';

class AuthProvider with ChangeNotifier {
  final Services _service = Services();

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- Initialization ---
  Future<void> initialize() async {
    _setLoading(true);
    await _checkLoginStatus();
    _setLoading(false);
  }

  Future<void> _checkLoginStatus() async {
    final bearerToken = await _service.api.tokenStorage.read(TokenType.bearer);
    if (bearerToken != null) {
      final isValid = await _refreshBearerToken();
      if (isValid) {
        _setLoggedIn(true);
      } else {
        await logout();
      }
    } else {
      _setLoggedIn(false);
    }
  }

  Future<bool> _refreshBearerToken() async {
    try {
      final refreshToken = await _service.api.tokenStorage.read(TokenType.refresh);
      if (refreshToken == null) return false;

      final bearerToken = await _service.api.updateToken();
      await _service.api.tokenStorage.write(TokenType.bearer, bearerToken);

      final decodedToken = JwtDecoder.decode(bearerToken);
      _currentUser = User.fromMap(decodedToken);
      logger.i('User refreshed: $_currentUser');

      return true;
    } catch (e) {
      logger.w('Token refresh failed: $e');
      return false;
    }
  }

  // --- Login / Logout ---
  Future<void> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final jwt = await _service.api.login(username, password);
      final decodedToken = JwtDecoder.decode(jwt.bearerToken);
      _currentUser = User.fromMap(decodedToken);
      logger.i('User loaded: $_currentUser');
      _setLoggedIn(true);
    } catch (e) {
      logger.w('Login error: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _service.api.tokenStorage.clearAll();
    _setLoggedIn(false);
  }

  void clearError() {
    _clearError();
    notifyListeners();
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
}
