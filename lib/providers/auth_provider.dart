import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/jwt_keys.dart';
import '../models/token_storage.dart';
import '../models/user.dart';
import '../screens/common/logger.dart';
import '../services/services.dart';

class AuthProvider with ChangeNotifier {
  final Services _service = Services();
  final TokenStorage _tokenStorage = TokenStorage();

  String? _bearerToken;
  String? _refreshToken;
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
    _bearerToken = await _tokenStorage.read(TokenType.bearer);

    if (_bearerToken != null) {
      final isValid = await _refreshBearerToken();
      if (isValid) {
        _setLoggedIn(true);
      } else {
        await logout(); // logout() already calls _setLoggedIn(false)
      }
    } else {
      _setLoggedIn(false);
    }
  }

  Future<bool> _refreshBearerToken() async {
    try {
      _refreshToken = await _tokenStorage.read(TokenType.refresh);
      if (_refreshToken == null) return false;

      _bearerToken = await _service.api.updateToken();
      await _tokenStorage.write(TokenType.bearer, _bearerToken);
      if (_bearerToken != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(_bearerToken!);
        _currentUser = User.fromMap(decodedToken);
        logger.i('User refreshed: $_currentUser');
      }
      return true;
    } catch (e) {
      logger.w('Token validation failed: $e');
      return false;
    }
  }

  // --- Login / Logout ---
  Future<void> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final jwt = await _service.api.login(username, password);
      await _saveTokens(jwt);
      _setLoggedIn(true);
    } catch (e) {
      logger.w('Login error: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _bearerToken = null;
    _refreshToken = null;
    await _tokenStorage.clearAll();
    _setLoggedIn(false);
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  // --- Private Methods ---

  Future<void> _saveTokens(JwtKeys jwt) async {
    _bearerToken = jwt.bearerToken;
    _refreshToken = jwt.refreshToken;

    await _tokenStorage.write(TokenType.bearer, _bearerToken);
    await _tokenStorage.write(TokenType.refresh, _refreshToken);

    // Decode token and set currentUser
    if (_bearerToken != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(_bearerToken!);
      _currentUser = User.fromMap(decodedToken);
      logger.i('User loaded: $_currentUser');
    }
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
