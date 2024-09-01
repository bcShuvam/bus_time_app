import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurestorageResponse {
  final String value;

  SecurestorageResponse({
    required this.value,
  });
}

class SecureStorage {
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> writeLoginCredentials(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<SecurestorageResponse> readLoginCredentials(String key) async {
    String value = await storage.read(key: key) ?? '';
    return SecurestorageResponse(value: value);
  }

  Future<void> deleteLoginCredentials(String key) async {
    await storage.delete(key: key);
  }
}
