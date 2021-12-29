import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:warehouse/constants.dart';

class SecureStorage {
  SecureStorage._();
  static late SecureStorage instance;
  late FlutterSecureStorage prefs;
  static void init() {
    instance = SecureStorage._();
    instance.prefs = const FlutterSecureStorage(
      aOptions: secureStorageAndroidOptions,
    );
  }
}
