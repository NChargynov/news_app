import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract final class SecureStorageKeys{
  static const String accessTokenKey = "accessTokenKey";
  static const String refreshTokenKey = "refreshTokenKey";
}

@LazySingleton()
class SecureStorageService {
  const SecureStorageService(this.flutterSecureStorage);

  final FlutterSecureStorage flutterSecureStorage;

  Future<void> save(String key, String value) async {
    return await flutterSecureStorage.write(key: key, value: value);
  }

  Future<String?> get(String key) async {
    return await flutterSecureStorage.read(key: key);
  }

  Future<void> deleteAll() async {
    return await flutterSecureStorage.deleteAll();
  }
}
