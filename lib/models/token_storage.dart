import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> write(StorageItem type, String? value) async {
    if (value != null) {
      await _storage.write(key: type.key, value: value);
    }
  }

  Future<String?> read(StorageItem type) async {
    return await _storage.read(key: type.key);
  }

  Future<void> delete(StorageItem type) async {
    await _storage.delete(key: type.key);
  }

  Future<void> clearAll() async {
    await Future.wait([
      delete(StorageItem.bearerToken),
      delete(StorageItem.refreshToken),
      delete(StorageItem.location),
    ]);
  }
}

enum StorageItem { bearerToken, refreshToken, location }

extension TokenTypeKey on StorageItem {
  String get key {
    switch (this) {
      case StorageItem.bearerToken:
        return 'bearer_token';
      case StorageItem.refreshToken:
        return 'refresh_token';
      case StorageItem.location:
        return 'location';
    }
  }
}
