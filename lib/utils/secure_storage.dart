import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static FlutterSecureStorage s = const FlutterSecureStorage();

  static Future save(String key) async{
    await s.write(key: "_$key", value: key);
  }

  static Future<String?> getData(String key)async{
    await s.read(key: key);
  }
}