import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> write(TokenType type, String? value) async {
    if (value != null) {
      await _storage.write(key: type.key, value: value);
    }
  }

  Future<String?> read(TokenType type) async {
    return await _storage.read(key: type.key);
  }

  Future<void> delete(TokenType type) async {
    await _storage.delete(key: type.key);
  }

  Future<void> clearAll() async {
    await Future.wait([
      delete(TokenType.bearer),
      delete(TokenType.refresh),
    ]);
  }
}

enum TokenType { bearer, refresh }

extension TokenTypeKey on TokenType {
  String get key {
    switch (this) {
      case TokenType.bearer:
        return 'bearer_token';
      case TokenType.refresh:
        return 'refresh_token';
    }
  }
}
