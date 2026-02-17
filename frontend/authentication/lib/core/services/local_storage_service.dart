import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

class LocalStorageService {
  static const _storage = FlutterSecureStorage();

  Future<void> saveToken(String token) =>
      _storage.write(key: AppConstants.tokenKey, value: token);

  Future<String?> getToken() => _storage.read(key: AppConstants.tokenKey);

  Future<void> clearToken() => _storage.delete(key: AppConstants.tokenKey);
}
