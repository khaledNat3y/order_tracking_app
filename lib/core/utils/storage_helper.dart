import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ));

  Future saveUserId(String userId) async {
    await storage.write(key: 'userId', value: userId);
  }

  Future<String?> getUserId() async {
    return await storage.read(key: 'userId');
  }

  Future removeUserId() async {
    await storage.delete(key: 'userId');
  }
}