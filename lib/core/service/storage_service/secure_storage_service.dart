import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class SecureStorageService {
  const SecureStorageService({required this.flutterSecureStorage});

  final FlutterSecureStorage flutterSecureStorage;

  Future<void> save(String key, String value) async {
    return await flutterSecureStorage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await flutterSecureStorage.read(key: key);
  }

  Future<void> deleteByKey(String key) async {
    return await flutterSecureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    return await flutterSecureStorage.deleteAll();
  }
}
